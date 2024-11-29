//
//  ArtistService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.11.2024.
//

protocol ArtistServiceProtocol {
    func getInfo(artistName: String, userId: String) async throws -> Artist
}
class ArtistService: ArtistServiceProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getInfo(artistName: String, userId: String) async throws -> Artist {
        let response: ArtistResponse = try await networkService.request(ArtistEndpoint.artistInfo(artistName: artistName, userId: userId))
        return response.artist
    }
}
