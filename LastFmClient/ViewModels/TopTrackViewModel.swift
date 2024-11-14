//
//  TopTrackViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import Foundation

struct TopTrackViewModel {
    private let track: TopTrack
    private let preferredImageSize: String

    init(track: TopTrack, preferredImageSize: String = "medium") {
        self.track = track
        self.preferredImageSize = preferredImageSize
    }

    var name: String {
        return track.name
    }
    
    var artistName: String {
        return track.artist.name
    }

    var playcount: Int {
        return Int(track.playcount) ?? 0
    }
    
    var rank: Int {
        return Int(track.rank.rank) ?? 0
    }

    var formattedPlaycount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: playcount)) ?? "\(playcount)"
    }

    var imageURL: URL? {
        guard let image = track.image.first(where: { $0.size == preferredImageSize }) else {
            return nil
        }
        return URL(string: image.url)
    }
}
