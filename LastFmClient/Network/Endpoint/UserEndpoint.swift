//
//  Endpoint.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

enum UserEndpoint {
    case topArtists(username: String, page: Int)
    case topTracks(username: String, page: Int)
    case topAlbums(username: String, page: Int)
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topArtists(let username, let page):
            return [.init(name: "method", value: "user.gettopartists"), .init(name: "user", value: username), .init(name: "page", value: "\(page)")]
        case .topTracks(let username, let page):
            return [.init(name: "method", value: "user.gettoptracks"), .init(name: "user", value: username), .init(name: "page", value: "\(page)")]
        case .topAlbums(let username, let page):
            return [.init(name: "method", value: "user.gettopalbums"), .init(name: "user", value: username), .init(name: "page", value: "\(page)")]
        }
    }
}
