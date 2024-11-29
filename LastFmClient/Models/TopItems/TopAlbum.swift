//
//  Album.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct TopAlbum: Playable {
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

struct TopAlbumsResponse: Decodable {
    
    struct TopAlbums: Decodable {
        let albums: [TopAlbum]
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
    
    let topAlbums: TopAlbums
    
    enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
}
