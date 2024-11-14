//
//  TopAlbumsViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import Foundation

protocol TopAlbumsViewModelProtocol {
    func fetchTopAlbums(userId: String) async
    func albumAtIndexPath(indexPath: IndexPath) -> TopAlbumViewModel
    
    var onFetchTopAlbums: (() -> Void)? { get set }
    var onError: ((LastFmError) -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    
    var numberOfRowsInSection: Int { get }
}

class TopAlbumsViewModel: TopAlbumsViewModelProtocol {
    
    var onFetchTopAlbums: (() -> Void)?
    var onError: ((any LastFmError) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    
    private let topAlbumsService: TopAlbumsServiceProtocol
    private var topAlbumViewModels = [TopAlbumViewModel]()
    
    private var currentPage = 1
    private var isFetching = false
    
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    init (topAlbumsService: TopAlbumsServiceProtocol) {
        self.topAlbumsService = topAlbumsService
    }
    
    var numberOfRowsInSection: Int {
        return topAlbumViewModels.count
    }
    
    func fetchTopAlbums(userId: String) async {
        currentPage = 1
        await fetchAlbums(userId: userId, page: currentPage)
    }
    
    func fetchMoreAlbums(userId: String) async {
        guard !isFetching else { return }
        isLoading = true
        await fetchAlbums(userId: userId, page: currentPage + 1)
        isLoading = false
    }
    
    private func fetchAlbums(userId: String, page: Int) async {
        guard !isFetching else { return }
        isFetching = true
        defer {
            isFetching = false
        }
        do {
            let albums: [TopAlbum] = try await topAlbumsService.fetchTopAlbums(userId: userId, page: page)
            let albumsViewModels = albums.map( { TopAlbumViewModel(album: $0) } )
            if page == 1 {
                self.topAlbumViewModels = albumsViewModels
            } else {
                self.topAlbumViewModels.append(contentsOf: albumsViewModels)
            }
            currentPage = page
            await MainActor.run {
                onFetchTopAlbums?()
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
    
    func albumAtIndexPath(indexPath: IndexPath) -> TopAlbumViewModel {
        return topAlbumViewModels[indexPath.row]
    }

}
