//
//  TopItemsTableViewCell.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.07.2025.
//

import UIKit

class TopItemsTableViewCell: UITableViewCell {

    let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCardStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCardStyle() {
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        contentView.addConstraints("V:|-6-[v0]-6-|", views: containerView)
        contentView.addConstraints("H:|-6-[v0]-6-|", views: containerView)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        layer.shadowPath = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            let shadowRect = self.containerView.convert(self.containerView.bounds, to: self)
            self.layer.shadowPath = UIBezierPath(
                roundedRect: shadowRect,
                cornerRadius: self.containerView.layer.cornerRadius
            ).cgPath
        }
    }
}

