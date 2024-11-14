//
//  TopTracksViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import Foundation

protocol TopTracksViewModelProtocol {
    func fetchTopTracks(userId: String) async
    func trackAtIndexPath(indexPath: IndexPath) -> TopTrackViewModel
    
    var onFetchTopTrack: (() -> Void)? { get set }
    var onError: ((LastFmError) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    var numberOfRowsInSection: Int { get }
}

class TopTracksViewModel: TopTracksViewModelProtocol {
    
    var onFetchTopTrack: (() -> Void)?
    
    
    var onFetchTopTracks: (() -> Void)?
    var onError: ((any LastFmError) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private let topTracksService: TopTracksServiceProtocol
    private var topTrackViewModels = [TopTrackViewModel]()
    
    private var currentPage = 1
    private var isFetching = false
    
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    init (topTracksService: TopTracksServiceProtocol) {
        self.topTracksService = topTracksService
    }
    
    var numberOfRowsInSection: Int {
        return topTrackViewModels.count
    }
    
    func fetchTopTracks(userId: String) async {
        currentPage = 1
        await fetchTracks(userId: userId, page: currentPage)
    }
    
    func fetchMoreTracks(userId: String) async {
        guard !isFetching else { return }
        isLoading = true
        await fetchTracks(userId: userId, page: currentPage + 1)
        isLoading = false
    }
    
    private func fetchTracks(userId: String, page: Int) async {
        guard !isFetching else { return }
        isFetching = true
        defer {
            isFetching = false
        }
        do {
            let tracks: [TopTrack] = try await topTracksService.fetchTopTracks(userId: userId, page: page)
            let tracksViewModels = tracks.map( { TopTrackViewModel(track: $0) } )
            if page == 1 {
                self.topTrackViewModels = tracksViewModels
            } else {
                self.topTrackViewModels.append(contentsOf: tracksViewModels)
            }
            currentPage = page
            await MainActor.run {
                onFetchTopTracks?()
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
    
    func trackAtIndexPath(indexPath: IndexPath) -> TopTrackViewModel {
        return topTrackViewModels[indexPath.row]
    }
}
