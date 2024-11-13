//
//  APIConfiguration.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

struct APIConfiguration {
    static let baseURL = "https://ws.audioscrobbler.com/2.0/"
    
    static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_KEY") as? String else {
            fatalError("API Key not set in build configuration")
        }
        return apiKey
    }
    
    static let formatQueryParameter: URLQueryItem = URLQueryItem(name: "format", value: "json")
    static let apiKeyQueryParameter: URLQueryItem = URLQueryItem(name: "api_key", value: apiKey)
}
