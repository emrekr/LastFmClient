//
//  TopAlbumViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import Foundation

struct TopAlbumViewModel {
    private let album: TopAlbum
    private let preferredImageSize: String

    init(album: TopAlbum, preferredImageSize: String = "medium") {
        self.album = album
        self.preferredImageSize = preferredImageSize
    }

    var name: String {
        return album.name
    }
    
    var artistName: String {
        return album.artist.name
    }

    var playcount: Int {
        return Int(album.playcount) ?? 0
    }
    
    var rank: Int {
        return Int(album.rank.rank) ?? 0
    }

    var formattedPlaycount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: playcount)) ?? "\(playcount)"
    }

    var imageURL: URL? {
        guard let image = album.image.first(where: { $0.size == preferredImageSize }) else {
            return nil
        }
        return URL(string: image.url)
    }
}
