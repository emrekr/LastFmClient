//
//  String+Extensions.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

import Foundation

extension String {
    var formatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let intValue = Int(self) else {
            return self
        }
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? "\(intValue)"
    }
}
