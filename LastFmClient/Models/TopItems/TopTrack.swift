//
//  Track.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct TopTrack: Playable {
    var name: String
    var playcount: String
    var image: [Image]
    var rank: Rank
    var artist: PlayableArtist
    
    enum CodingKeys: String, CodingKey {
        case name, playcount, image, artist
        case rank = "@attr"
    }
}

struct TopTracksResponse: Decodable {
    struct TopTracks: Decodable {
        var tracks: [TopTrack]
        
        enum CodingKeys: String, CodingKey {
            case tracks = "track"
        }
    }
    let topTracks: TopTracks
    
    enum CodingKeys: String, CodingKey {
        case topTracks = "toptracks"
    }
}
