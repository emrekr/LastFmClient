//
//  MockNetworkService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 5.12.2024.
//

@testable import LastFmClient
import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var responseData: Data?
    var error: Error?

    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        if let error = error {
            throw error
        }
        guard let data = responseData else {
            throw LastFmError.api(.unknownError)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

class MockTopItemsService: UserServiceProtocol {
    func fetch<T>(endpoint: LastFmClient.UserEndpoint) async throws -> T where T : Decodable {
        if let error = error {
            throw error
        }
        guard let data = responseData as? T else {
            throw LastFmError.network(.decodingError(NSError(domain: "", code: -1, userInfo: nil)))
        }
        return data
    }
    
    var responseData: Any?
    var error: Error?
}

class MockTopArtistsService: TopArtistsServiceProtocol {
    var shouldReturnError: Bool = false
    var error: Error?
    var shouldReturnArtists: [TopArtist] = []
    
    func fetchTopArtists(userId: String, page: Int) async throws -> [TopArtist] {
        if shouldReturnError {
            throw error ?? LastFmError.api(.unknownError)
        }
        return shouldReturnArtists
    }
}

class MockArtistService: ArtistServiceProtocol {
    var shouldReturnError: Bool = false
    var artistInfo: Artist?
    
    func getInfo(artistName: String, userId: String) async throws -> Artist {
        if shouldReturnError {
            throw LastFmError.api(.unknownError)
        }
        guard let artistInfo = artistInfo else {
            throw LastFmError.api(.unknownError)
        }
        return artistInfo
    }
}
