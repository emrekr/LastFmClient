//
//  TopTrackViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import Foundation

class TopTrackViewModel {
    private let track: TopTrack
    private let preferredImageSize: String
    private let artistService: ArtistServiceProtocol
    private var isFetchingImage = false
    
    var onImageUpdate: (() -> Void)?
    
    var artistInfo: Artist? {
        didSet {
            onImageUpdate?()
        }
    }

    init(track: TopTrack, artistService: ArtistServiceProtocol,preferredImageSize: String = "medium") {
        self.track = track
        self.preferredImageSize = preferredImageSize
        self.artistService = artistService
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
    
    private var rank: Int {
        return Int(track.rank.rank) ?? 0
    }
    
    var formattedRank: String {
        return "\(rank)."
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
    
    func fetchArtistInfo(userId: String) async {
        guard artistInfo == nil, !isFetchingImage else { return }
        isFetchingImage = true
        defer { isFetchingImage = false }
        
        do {
            let artistInfo = try await artistService.getInfo(artistName: artistName, userId: userId)
            self.artistInfo = artistInfo
        } catch {
            print("Failed to fetch image for \(name): \(error)")
        }
    }
}
