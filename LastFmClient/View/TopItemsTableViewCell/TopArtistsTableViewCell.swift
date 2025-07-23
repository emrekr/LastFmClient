//
//  TopArtistsTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

class TopArtistTableViewCell: TopItemsTableViewCell {
    
    // MARK: - UI Elements
    private let nameLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.nameLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playcountLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.playcountLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        containerView.addSubview(artistImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(playcountLabel)
        containerView.addSubview(progressView)

        containerView.addConstraints("H:|-10-[v0(64)]-10-[v1]-(>=10)-[v2]-10-|", views: artistImageView, nameLabel, playcountLabel)
        containerView.addConstraints("H:|-10-[v0(64)]-10-[v1]-10-|", views: artistImageView, progressView)
        containerView.addConstraints("V:|-10-[v0]-10-[v1(6)]-10-|", views: nameLabel, progressView)
        containerView.addConstraints("V:|-10-[v0]-10-|", views: playcountLabel)
        containerView.addConstraints("V:|-10-[v0(64)]-10-|", views: artistImageView)
                
        NSLayoutConstraint.activate([
            artistImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
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
    
    // MARK: - Configure Cell
    func configure(with viewModel: TopArtistViewModel, ratio: CGFloat) {
        nameLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
        
        currentImageURL = viewModel.imageURL
        
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
}
