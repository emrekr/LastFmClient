//
//  ArtistEndpoint.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.11.2024.
//

import Foundation

enum ArtistEndpoint {
    case artistInfo(artistName: String, userId: String)
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .artistInfo(let artistName, let userId):
            return [.init(name: "method", value: "artist.getInfo"), .init(name: "artist", value: artistName), .init(name: "user", value: userId)]
        }
    }
}
