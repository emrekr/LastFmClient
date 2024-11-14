//
//  NetworkError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

enum NetworkError: LastFmError {
    case invalidURL
    case decodingError(Error)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid Url"
        case .decodingError(let error):
            return error.localizedDescription
        }
    }
}
