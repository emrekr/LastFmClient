//
//  TopAlbumsTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopAlbumsTableViewCell: UITableViewCell {
    
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
        label.numberOfLines = 0
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
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
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
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(playcountLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(albumImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        
        contentView.addConstraints("H:|-10-[v0]-20-[v1(64)]-10-[v2]-(>=10)-[v3]-20-|", views: rankLabel, albumImageView, stackView, playcountLabel)
        contentView.addConstraints("V:[v0(64)]", views: albumImageView)
        contentView.addConstraintsToSubviews("V:|-10-[v0]-10-|")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let url = currentImageURL {
            Task {
                await imageLoader?.cancelLoad(for: url)
            }
        }
        currentImageURL = nil
        albumImageView.image = nil
    }
    
    // MARK: - Configure Cell

    func configure(with viewModel: TopAlbumViewModel) {
        rankLabel.text = viewModel.formattedRank
        titleLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
        artistLabel.text = viewModel.artistName

        currentImageURL = viewModel.imageURL
        albumImageView.image = nil

        if let imageUrl = currentImageURL {
            Task {
                if let image = await imageLoader?.loadImage(from: imageUrl),
                   self.currentImageURL == imageUrl {
                    self.albumImageView.image = image
                }
            }
        }
    }
}
