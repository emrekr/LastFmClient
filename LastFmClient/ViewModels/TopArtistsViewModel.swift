//
//  TopArtistsViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import Foundation

protocol TopArtistsViewModelProtocol {
    func fetchTopArtists(userId: String) async
    func artistAtIndexPath(indexPath: IndexPath) -> ArtistViewModel
    
    var onFetchTopArtists: (() -> Void)? { get set }
    var onError: ((APIError) -> Void)? { get set }
    
    var numberOfRowsInSection: Int { get }
}

class TopArtistsViewModel: TopArtistsViewModelProtocol {
    
    var onFetchTopArtists: (() -> Void)?
    var onError: ((APIError) -> Void)?
    
    private let topArtistsService: TopArtistsServiceProtocol
    private var artistViewModels = [ArtistViewModel]()
    
    init (topArtistsService: TopArtistsServiceProtocol) {
        self.topArtistsService = topArtistsService
    }
    
    var numberOfRowsInSection: Int {
        return artistViewModels.count
    }
    
    func fetchTopArtists(userId: String) async {
        do {
            let artists = try await topArtistsService.fetchTopArtists(userId: userId)
            self.artistViewModels = artists.map { ArtistViewModel(artist: $0) }
            await MainActor.run {
                self.onFetchTopArtists?()
            }
        } catch let error {
            await MainActor.run {
                handle(error: error)
            }
        }
    }
    
    private func handle(error: Error) {
        let apiError = (error as? APIError) ?? .unknownError
        self.onError?(apiError)
    }
    
    func artistAtIndexPath(indexPath: IndexPath) -> ArtistViewModel {
        return artistViewModels[indexPath.row]
    }
    
}
