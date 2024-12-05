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
            throw NetworkError.invalidURL
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

class MockTopItemsService: TopItemsServiceProtocol {
    func fetch<T>(endpoint: LastFmClient.UserEndpoint) async throws -> T where T : Decodable {
        if let error = error {
            throw error
        }
        guard let data = responseData as? T else {
            throw NetworkError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        }
        return data
    }
    
    var responseData: Any?
    var error: Error?
}
