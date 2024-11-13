//
//  TopItemsService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

protocol TopItemsServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
}

class TopItemsService: TopItemsServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        return try await networkService.request(endpoint)
    }
}
