//
//  SegmentedContolStyles.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.07.2025.
//

import UIKit

enum SegmentedControlStyles {

    enum Button {
        static let normal = Style<UIButton> {
            $0.setTitleColor(.gray, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        }

        static let selected = Style<UIButton> {
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }

    enum Underline {
        static let defaultStyle = Style<UIView> {
            $0.backgroundColor = .black
        }
        
        static let height: CGFloat = 2
        static let animationDuration: TimeInterval = 0.25
    }
    
    enum StackView {
        static let defaultStyle = Style<UIStackView> {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
    }
}

