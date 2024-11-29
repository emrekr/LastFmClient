//
//  Playable.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

protocol Playable: LastFmItem {
    var artist: PlayableArtist { get }
}

struct PlayableArtist: Decodable {
    let name: String
}
