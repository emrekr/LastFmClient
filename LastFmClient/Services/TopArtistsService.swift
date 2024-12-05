//
//  TopArtistsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopArtistsServiceProtocol {
    func fetchTopArtists(userId: String, page: Int) async throws -> [TopArtist]
}

class TopArtistsService: TopArtistsServiceProtocol {
    private let topItemsService: TopItemsServiceProtocol
    
    init(networkService: TopItemsServiceProtocol = TopItemsService()) {
        self.topItemsService = networkService
    }
    
    func fetchTopArtists(userId: String, page: Int) async throws -> [TopArtist] {
        guard page > 0 else {
            throw NetworkError.invalidParameter("Page number must be greater than 0")
        }
        let response: TopArtistsResponse = try await topItemsService.fetch(endpoint: .topArtists(username: userId, page: page))
        return response.topArtists.artists
    }
}
