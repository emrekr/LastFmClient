//
//  TopTracksTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopTracksTableViewCell: TopItemsTableViewCell {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.nameLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.artistLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playcountLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.playcountLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView().style(TopItemsTableViewCellStyles.ImageView.artistImageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let progressView: ProgressBarView = {
        let progressView = ProgressBarView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    var imageLoader: ImageLoaderProtocol?
    private var currentImageURL: URL?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.addSubview(playcountLabel)
        containerView.addSubview(stackView)
        containerView.addSubview(artistImageView)
        containerView.addSubview(progressView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        
        containerView.addConstraints("H:|-10-[v0(64)]-10-[v1]-(>=10)-[v2]-20-|", views: artistImageView, stackView, playcountLabel)
        containerView.addConstraints("H:|-10-[v0(64)]-10-[v1]-10-|", views: artistImageView, progressView)
        containerView.addConstraints("V:|-10-[v0]-10-[v1(6)]-10-|", views: stackView, progressView)
        containerView.addConstraints("V:|-10-[v0]-10-|", views: playcountLabel)
    }
    
    // MARK: - Configure Cell
    func configure(with viewModel: TopTrackViewModel, ratio: CGFloat) {
        titleLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
        artistLabel.text = viewModel.artistName

        progressView.setProgress(ratio: ratio)
        
        if let artistInfo = viewModel.artistInfo {
            if let imageUrl = artistInfo.image.first(where: {$0.size == "medium"})?.url {
                currentImageURL = URL(string: imageUrl)
                loadArtistImage(imageUrl: imageUrl)
            }
        }

        viewModel.onImageUpdate = { [weak self] in
            if let imageUrl = viewModel.artistInfo?.image.first(where: {$0.size == "medium"})?.url {
                self?.loadArtistImage(imageUrl: imageUrl)
            }
        }
    }
    
    private func loadArtistImage(imageUrl: String) {
        Task {
            if let image = await imageLoader?.loadImage(from: URL(string: imageUrl)!) {
                self.artistImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let url = currentImageURL {
            Task {
                await imageLoader?.cancelLoad(for: url)
            }
        }
        artistImageView.image = nil
        currentImageURL = nil
    }
}
