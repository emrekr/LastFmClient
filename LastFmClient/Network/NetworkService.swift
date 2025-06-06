//
//  NetworkService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()

    private init() {}
    
    func request<T>(_ endpoint: EndpointProtocol) async throws -> T where T : Decodable {
        var urlComponents = URLComponents(string: APIConfiguration.baseURL)!
        urlComponents.queryItems = [APIConfiguration.apiKeyQueryParameter, APIConfiguration.formatQueryParameter]
        urlComponents.queryItems?.append(contentsOf: endpoint.queryItems)
        
        guard let url = urlComponents.url else {
            throw LastFmError.network(.invalidURL)
        }

        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            throw APIError(errorCode: errorResponse.error)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch let decodingError {
            throw LastFmError.network(.decodingError(decodingError))
        }
    }
}
