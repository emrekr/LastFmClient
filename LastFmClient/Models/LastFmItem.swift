//
//  PlayableItem.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol LastFmItem: Decodable {
    var name: String { get }
    var playcount: String { get }
    var image: [Image] { get }
    var rank: Rank { get }
}

struct Image: Decodable {
    let size: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case size
        case url = "#text" // Maps "#text" key to url property
    }
}

struct Rank: Decodable {
    let rank: String
}
