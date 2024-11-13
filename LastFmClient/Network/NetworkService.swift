//
//  NetworkService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()

    private init() {}
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        var urlComponents = URLComponents(string: APIConfiguration.baseURL)!
        urlComponents.queryItems = [APIConfiguration.apiKeyQueryParameter, APIConfiguration.formatQueryParameter]
        urlComponents.queryItems?.append(contentsOf: endpoint.queryItems)
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        do {
            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError(errorCode: errorResponse.error)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch let decodingError {
            throw NetworkError.decodingError(decodingError)
        }
    }
}
