//
//  TopArtistsViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import Foundation

protocol TopArtistsViewModelProtocol {
    func fetchTopArtists(userId: String) async
    func artistAtIndexPath(indexPath: IndexPath) -> TopArtistViewModel
    
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
    private let artistService: ArtistServiceProtocol
    private var artistViewModels = [TopArtistViewModel]()
    
    private var currentPage = 1
    private var isFetching = false
    
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    init(topArtistsService: TopArtistsServiceProtocol, artistService: ArtistServiceProtocol) {
        self.topArtistsService = topArtistsService
        self.artistService = artistService
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
        defer { isFetching = false }

        do {
            let artists = try await topArtistsService.fetchTopArtists(userId: userId, page: page)
            let artistViewModels = artists.map { artist in
                let viewModel = TopArtistViewModel(artist: artist, artistService: artistService)
                Task {
                    await viewModel.fetchArtistInfo(userId: userId)
                }
                return viewModel
            }
            if page == 1 {
                self.artistViewModels = artistViewModels
            } else {
                self.artistViewModels.append(contentsOf: artistViewModels)
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
    
    func artistAtIndexPath(indexPath: IndexPath) -> TopArtistViewModel {
        return artistViewModels[indexPath.row]
    }
    
}
