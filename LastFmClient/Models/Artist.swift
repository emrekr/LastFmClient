//
//  Artist.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct Artist: PlayableItem {
    let name: String
    let playcount: String
}

struct TopArtistsResponse: Decodable {
    struct TopArtists: Decodable {
        let artists: [Artist]
        
        enum CodingKeys: String, CodingKey {
            case artists = "artist"
        }
    }
    let topArtists: TopArtists
    
    enum CodingKeys: String, CodingKey {
        case topArtists = "topartists"
    }
}

