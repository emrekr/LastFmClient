//
//  NetworkError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

enum NetworkError: LastFmError, Equatable {
    case invalidURL
    case decodingError(Error)
    case invalidParameter(String)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid Url"
        case .decodingError(let error):
            return error.localizedDescription
        case .invalidParameter(let message):
            return message
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return (lhsError as NSError).code == (rhsError as NSError).code && (lhsError as NSError).domain == (rhsError as NSError).domain
        case (.invalidParameter(let lhsMessage), .invalidParameter(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
