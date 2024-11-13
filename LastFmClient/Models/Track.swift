//
//  Track.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct Track: PlayableItem {
    var name: String
    var playcount: String
}

struct TopTracksResponse: Decodable {
    struct TopTracks: Decodable {
        var tracks: [Track]
        
        enum CodingKeys: String, CodingKey {
            case tracks = "track"
        }
    }
    let topTracks: TopTracks
    
    enum CodingKeys: String, CodingKey {
        case topTracks = "toptracks"
    }
}
