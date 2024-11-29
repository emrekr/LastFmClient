//
//  Endpoint.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.11.2024.
//

import Foundation

protocol EndpointProtocol {
    var queryItems: [URLQueryItem] { get }
}

extension UserEndpoint: EndpointProtocol {}
extension ArtistEndpoint: EndpointProtocol {}
