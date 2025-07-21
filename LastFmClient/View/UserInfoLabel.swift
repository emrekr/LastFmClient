//
//  UserInfoLabel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

import UIKit

class UserInfoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .systemFont(ofSize: 14, weight: .medium)
        self.textColor = .darkGray
        self.numberOfLines = 2
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
