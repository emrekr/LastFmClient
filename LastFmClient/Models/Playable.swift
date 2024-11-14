//
//  Playable.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

protocol Playable: LastFmItem {
    var artist: Artist { get }
}

struct Artist: Decodable {
    let name: String
}
