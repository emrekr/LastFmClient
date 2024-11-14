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
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
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
        
        contentView.addConstraints("H:|-10-[v0]-20-[v1]-(>=10)-[v2]-10-|", views: rankLabel, nameLabel, playcountLabel)
        contentView.addConstraintsToSubviews("V:|-10-[v0]-10-|")
    }
    
    // MARK: - Configure Cell
    func configure(with viewModel: TopArtistViewModel) {
        rankLabel.text = "\(viewModel.rank)."
        nameLabel.text = viewModel.name
        playcountLabel.text = viewModel.formattedPlaycount
    }
}
