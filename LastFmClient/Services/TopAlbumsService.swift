//
//  TopAlbumsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopAlbumsServiceProtocol {
    func fetchTopAlbums(userId: String, page: Int) async throws -> [TopAlbum]
}

class TopAlbumsService: TopAlbumsServiceProtocol {
    private let topItemsService: UserServiceProtocol
    
    init(networkService: UserServiceProtocol = UserService()) {
        self.topItemsService = networkService
    }
    
    func fetchTopAlbums(userId: String, page: Int) async throws -> [TopAlbum] {
        guard page > 0 else {
            throw LastFmError.network(.invalidParameter("Page number must be greater than 0"))
        }
        let response: TopAlbumsResponse = try await topItemsService.fetch(endpoint: .topAlbums(username: userId, page: page))
        return response.topAlbums.albums
    }
}
