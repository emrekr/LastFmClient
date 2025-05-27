//
//  Artist.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct TopArtist: LastFmItem {
    let name: String
    let playcount: String
    var image: [Image]
    var rank: Rank
    
    enum CodingKeys: String, CodingKey {
        case name, playcount, image
        case rank = "@attr"
    }
}

struct TopArtistsResponse: Decodable {
    struct TopArtists: Decodable {
        let artists: [TopArtist]
        
        enum CodingKeys: String, CodingKey {
            case artists = "artist"
        }
    }
    let topArtists: TopArtists
    
    enum CodingKeys: String, CodingKey {
        case topArtists = "topartists"
    }
}

