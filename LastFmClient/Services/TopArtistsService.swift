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
    private let userService: UserServiceProtocol
    
    init(networkService: UserServiceProtocol = UserService()) {
        self.userService = networkService
    }
    
    func fetchTopArtists(userId: String, page: Int) async throws -> [TopArtist] {
        guard page > 0 else {
            throw LastFmError.network(.invalidParameter("Page number must be greater than 0"))
        }
        let response: TopArtistsResponse = try await userService.fetch(endpoint: .topArtists(username: userId, page: page))
        return response.topArtists.artists
    }
}
