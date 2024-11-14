//
//  TopTracksService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopTracksServiceProtocol {
    func fetchTopTracks(userId: String, page: Int) async throws -> [TopTrack]
}

class TopTracksService: TopTracksServiceProtocol {
    private let topItemsService: TopItemsServiceProtocol
    
    init(networkService: TopItemsServiceProtocol = TopItemsService()) {
        self.topItemsService = networkService
    }
    
    func fetchTopTracks(userId: String, page: Int) async throws -> [TopTrack] {
        let response: TopTracksResponse = try await topItemsService.fetch(endpoint: .topTracks(username: userId, page: page))
        return response.topTracks.tracks
    }
}
