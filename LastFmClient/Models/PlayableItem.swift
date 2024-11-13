//
//  PlayableItem.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol PlayableItem: Decodable {
    var name: String { get }
    var playcount: String { get }
}
