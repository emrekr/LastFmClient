//
//  ArtistViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import Foundation

struct TopArtistViewModel {
    private let artist: TopArtist
    private let preferredImageSize: String

    init(artist: TopArtist, preferredImageSize: String = "large") {
        self.artist = artist
        self.preferredImageSize = preferredImageSize
    }

    var name: String {
        return artist.name
    }

    var playcount: Int {
        return Int(artist.playcount) ?? 0
    }
    
    var rank: Int {
        return Int(artist.rank.rank) ?? 0
    }

    var formattedPlaycount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: playcount)) ?? "\(playcount)"
    }

    var imageURL: URL? {
        guard let image = artist.image.first(where: { $0.size == preferredImageSize }) else {
            return nil
        }
        return URL(string: image.url)
    }
}
