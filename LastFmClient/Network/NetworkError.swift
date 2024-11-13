//
//  NetworkError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 12.11.2024.
//

enum NetworkError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(Error)
}
