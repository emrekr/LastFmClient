//
//  PlayableItem.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol PlayableItem: Decodable {
    var name: String { get }
    var playcount: String { get }
    var image: [Image] { get }
}

struct Image: Decodable {
    let size: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case size
        case url = "#text" // Maps "#text" key to url property
    }
}
