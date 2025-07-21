//
//  TopArtistsTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

class TopArtistTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let rankLabel: UILabel = {
        let label = UILabel().style(TopItemsTableViewCellStyles.Label.rankLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(playcountLabel)
        contentView.addSubview(artistImageView)
        
        contentView.addConstraints("H:|-10-[v0]-20-[v1(64)]-10-[v2]-(>=10)-[v3]-10-|", views: rankLabel, artistImageView, nameLabel, playcountLabel)
        contentView.addConstraints("V:[v0(64)]", views: artistImageView)
        contentView.addConstraintsToSubviews("V:|-10-[v0]-10-|")
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
    func configure(with viewModel: TopArtistViewModel) {
        rankLabel.text = viewModel.formattedRank
        nameLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
        
        currentImageURL = viewModel.imageURL
        
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
