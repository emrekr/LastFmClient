//
//  TopItemsTableViewCellStyles.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.07.2025.
//

import UIKit

enum TopItemsTableViewCellStyles {
    
    enum Label {
        static let rankLabel = Style<UILabel> {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .blue
        }
        
        static let nameLabel = Style<UILabel> {
            $0.font = .boldSystemFont(ofSize: 16)
            $0.numberOfLines = 1
        }
        
        static let playcountLabel = Style<UILabel> {
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 1
            $0.textColor = .gray
        }
        
        static let artistLabel = Style<UILabel> {
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 1
            $0.textColor = .gray
        }
    }
    
    enum ImageView {
        static let artistImageView = Style<UIImageView> {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 32
            $0.clipsToBounds = true
        }
    }
    
}


