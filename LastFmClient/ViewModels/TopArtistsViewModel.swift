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
    var onError: ((LastFmError) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    var numberOfRowsInSection: Int { get }
}

class TopArtistsViewModel: TopArtistsViewModelProtocol {
    
    var onFetchTopArtists: (() -> Void)?
    var onError: ((LastFmError) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private let topArtistsService: TopArtistsServiceProtocol
    private var artistViewModels = [ArtistViewModel]()
    
    private var currentPage = 1
    private var isFetching = false
    
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    init (topArtistsService: TopArtistsServiceProtocol) {
        self.topArtistsService = topArtistsService
    }
    
    var numberOfRowsInSection: Int {
        return artistViewModels.count
    }
    
    func fetchTopArtists(userId: String) async {
        currentPage = 1
        await fetchArtists(userId: userId, page: currentPage)
    }

    func fetchMoreArtists(userId: String) async {
        guard !isFetching else { return }
        isLoading = true
        await fetchArtists(userId: userId, page: currentPage + 1)
        isLoading = false
    }
    
    private func fetchArtists(userId: String, page: Int) async {
        guard !isFetching else { return }
        isFetching = true
        defer {
            isFetching = false
        }
        do {
            let artists = try await topArtistsService.fetchTopArtists(userId: userId, page: page)
            let artisViewModels = artists.map( { ArtistViewModel(artist: $0) } )
            if page == 1 {
                self.artistViewModels = artisViewModels
            } else {
                self.artistViewModels.append(contentsOf: artisViewModels)
            }
            currentPage = page
            await MainActor.run {
                onFetchTopArtists?()
            }
        } catch let error {
            await MainActor.run {
                handle(error: error)
            }
        }
    }
    
    private func handle(error: Error) {
        let apiError = (error as? LastFmError) ?? APIError.unknownError
        self.onError?(apiError)
    }
    
    func artistAtIndexPath(indexPath: IndexPath) -> ArtistViewModel {
        return artistViewModels[indexPath.row]
    }
    
}
