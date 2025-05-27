//
//  TopTracksTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopTracksTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playcountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .gray
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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var imageLoader: ImageLoaderProtocol?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(playcountLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(artistImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        
        contentView.addConstraints("H:|-10-[v0]-20-[v1(64)]-10-[v2]-(>=10)-[v3]-20-|", views: rankLabel, artistImageView, stackView, playcountLabel)
        contentView.addConstraints("V:[v0(64)]", views: artistImageView)
        contentView.addConstraintsToSubviews("V:|-10-[v0]-10-|")
    }
    
    // MARK: - Configure Cell
    func configure(with viewModel: TopTrackViewModel) {
        rankLabel.text = viewModel.formattedRank
        titleLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
        artistLabel.text = viewModel.artistName
        
        if let artistInfo = viewModel.artistInfo {
            if let imageUrl = artistInfo.image.first(where: {$0.size == "medium"})?.url {
                loadArtistImage(imageUrl: imageUrl)
            }
        } else if let imageURL = viewModel.imageURL {
            imageLoader?.loadImage(from: imageURL, completion: { [weak self] image in
                DispatchQueue.main.async {
                    self?.artistImageView.image = image
                }
            })
        }

        viewModel.onImageUpdate = { [weak self] in
            if let imageUrl = viewModel.artistInfo?.image.first(where: {$0.size == "medium"})?.url {
                self?.loadArtistImage(imageUrl: imageUrl)
            }
        }
    }
    
    private func loadArtistImage(imageUrl: String) {
        self.imageLoader?.loadImage(from: URL(string: imageUrl)!) { [weak self] image in
            DispatchQueue.main.async {
                self?.artistImageView.image = image
            }
        }
    }
}
