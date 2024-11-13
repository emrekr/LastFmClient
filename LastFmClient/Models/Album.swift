//
//  Album.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

struct Album: PlayableItem {
    var name: String
    var playcount: String
    var image: [Image]
}

struct TopAlbumsResponse: Decodable {
    
    struct TopAlbums: Decodable {
        let albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
    
    let topAlbums: TopAlbums
    
    enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
}
