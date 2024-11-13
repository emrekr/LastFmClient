//
//  TopAlbumsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopAlbumsServiceProtocol {
    func fetchTopAlbums(userId: String) async throws -> [Album]
}

class TopAlbumsService: TopAlbumsServiceProtocol {
    private let topItemsService: TopItemsServiceProtocol
    
    init(networkService: TopItemsServiceProtocol = TopItemsService()) {
        self.topItemsService = networkService
    }
    
    func fetchTopAlbums(userId: String) async throws -> [Album] {
        let response: TopAlbumsResponse = try await topItemsService.fetch(endpoint: .topAlbums(username: userId))
        return response.topAlbums.albums
    }
}
