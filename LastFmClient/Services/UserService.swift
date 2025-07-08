//
//  TopItemsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol UserServiceProtocol {
    func fetch<T: Decodable>(endpoint: UserEndpoint) async throws -> T
}

class UserService: UserServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetch<T: Decodable>(endpoint: UserEndpoint) async throws -> T {
        return try await networkService.request(endpoint)
    }
}
