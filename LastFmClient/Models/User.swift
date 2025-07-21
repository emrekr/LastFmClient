//
//  User.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

struct User: Decodable {
    let name: String
    let playcount: String
    let artist_count: String
    let track_count: String
    let album_count: String
}

struct UserResponse: Decodable {
    let user: User
}
