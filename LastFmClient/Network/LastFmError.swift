//
//  LastFmError.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

protocol LastFmError: Error {
    var message: String { get }
}
