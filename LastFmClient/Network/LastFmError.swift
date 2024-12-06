//
//  LastFmError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

enum LastFmError: Error, Equatable {
    case network(NetworkError)
    case api(APIError)
    case other(String)

    var message: String {
        switch self {
        case .network(let error):
            return error.message
        case .api(let error):
            return error.message
        case .other(let message):
            return message
        }
    }
    
    static func == (lhs: LastFmError, rhs: LastFmError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhs), .network(let rhs)):
            return lhs == rhs
        case (.api(let lhs), .api(let rhs)):
            return lhs == rhs
        case (.other(let lhs), .other(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
