//
//  TopArtistsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopArtistsServiceProtocol {
    func fetchTopArtists(userId: String) async throws -> [Artist]
}

class TopArtistsService: TopArtistsServiceProtocol {
    private let topItemsService: TopItemsServiceProtocol
    
    init(networkService: TopItemsServiceProtocol = TopItemsService()) {
        self.topItemsService = networkService
    }
    
    func fetchTopArtists(userId: String) async throws -> [Artist] {
        let response: TopArtistsResponse = try await topItemsService.fetch(endpoint: .topArtists(username: userId))
        return response.topArtists.artists
    }
}
