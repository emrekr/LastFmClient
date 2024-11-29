//
//  Artist.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.11.2024.
//

struct Artist: Decodable {
    let name: String
    let image: [Image]
}

struct ArtistResponse: Decodable {
    let artist: Artist
}
