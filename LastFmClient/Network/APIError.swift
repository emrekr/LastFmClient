//
//  APIError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

import Foundation

struct APIErrorResponse: Decodable {
    let message: String
    let error: Int
}

enum APIError: Error, LocalizedError {
    case invalidService
    case invalidMethod
    case authenticationFailed
    case invalidFormat
    case invalidParameters
    case invalidResource
    case operationFailed
    case invalidSessionKey
    case invalidApiKey
    case serviceOffline
    case invalidMethodSignature
    case temporaryError
    case suspendedApiKey
    case rateLimitExceeded
    case unknownError

    init(errorCode: Int) {
        switch errorCode {
        case 2: self = .invalidService
        case 3: self = .invalidMethod
        case 4: self = .authenticationFailed
        case 5: self = .invalidFormat
        case 6: self = .invalidParameters
        case 7: self = .invalidResource
        case 8: self = .operationFailed
        case 9: self = .invalidSessionKey
        case 10: self = .invalidApiKey
        case 11: self = .serviceOffline
        case 13: self = .invalidMethodSignature
        case 16: self = .temporaryError
        case 26: self = .suspendedApiKey
        case 29: self = .rateLimitExceeded
        default: self = .unknownError
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidService:
            return "Invalid service - This service does not exist."
        case .invalidMethod:
            return "Invalid method - No method with that name in this package."
        case .authenticationFailed:
            return "Authentication failed - You do not have permissions to access the service."
        case .invalidFormat:
            return "Invalid format - This service doesn't exist in that format."
        case .invalidParameters:
            return "Invalid parameters - Your request is missing a required parameter."
        case .invalidResource:
            return "Invalid resource specified."
        case .operationFailed:
            return "Operation failed - Something went wrong."
        case .invalidSessionKey:
            return "Invalid session key - Please re-authenticate."
        case .invalidApiKey:
            return "Invalid API key - You must be granted a valid key by Last.fm."
        case .serviceOffline:
            return "Service offline - This service is temporarily unavailable. Try again later."
        case .invalidMethodSignature:
            return "Invalid method signature supplied."
        case .temporaryError:
            return "Temporary error - Please try again."
        case .suspendedApiKey:
            return "Suspended API key - Access has been suspended; contact Last.fm support."
        case .rateLimitExceeded:
            return "Rate limit exceeded - Too many requests in a short period."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
