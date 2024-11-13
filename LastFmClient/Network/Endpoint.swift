//
//  Endpoint.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

enum Endpoint {
    case topArtists(username: String)
    case topTracks(username: String)
    case topAlbums(username: String)
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topArtists(let username):
            return [.init(name: "method", value: "user.gettopartists"), .init(name: "user", value: username)]
        case .topTracks(let username):
            return [.init(name: "method", value: "user.gettoptracks"), .init(name: "user", value: username)]
        case .topAlbums(let username):
            return [.init(name: "method", value: "user.gettopalbums"), .init(name: "user", value: username)]
        }
    }
}
