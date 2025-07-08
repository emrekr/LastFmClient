//
//  ArtistViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

class TopArtistViewModel {
    private let artist: TopArtist
    private let preferredImageSize: String
    
    var artistInfo: Artist? {
        didSet {
            onImageUpdate?()
        }
    }
    
    var onImageUpdate: (() -> Void)?
    
    private let artistService: ArtistServiceProtocol
    private var isFetchingImage = false
    

    init(artist: TopArtist, artistService: ArtistServiceProtocol, preferredImageSize: String = "medium") {
        self.artist = artist
        self.preferredImageSize = preferredImageSize
        self.artistService = artistService
    }

    var name: String {
        return artist.name
    }

    private var playcount: Int {
        return Int(artist.playcount) ?? 0
    }
    
    private var rank: Int {
        return Int(artist.rank.rank) ?? 0
    }
    
    var formattedRank: String {
        return "\(rank)."
    }

    var formattedPlaycount: String {
        return artist.playcount.formatted
    }

    var imageURL: URL? {
        guard let image = self.artist.image.first(where: { $0.size == preferredImageSize }) else {
            return nil
        }
        return URL(string: image.url)
    }
    
    func fetchArtistInfo(userId: String) async {
        guard artistInfo == nil, !isFetchingImage else { return }
        isFetchingImage = true
        defer { isFetchingImage = false }
        
        do {
            let artistInfo = try await artistService.getInfo(artistName: name, userId: userId)
            self.artistInfo = artistInfo
        } catch {
            print("Failed to fetch image for \(name): \(error)")
        }
    }
}
