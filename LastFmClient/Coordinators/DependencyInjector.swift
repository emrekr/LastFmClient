//
//  DependencyInjector.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

class DependencyInjector {
    // Singleton instance
    static let shared = DependencyInjector()
    
    private init() {}
 
    // Lazy-initialized properties for services with protocols as types
    private lazy var topArtistsService: TopArtistsServiceProtocol = {
        TopArtistsService()
    }()
    
    private lazy var topAlbumsService: TopAlbumsServiceProtocol = {
        TopAlbumsService()
    }()
    
    private lazy var topTracksService: TopTracksServiceProtocol = {
        TopTracksService()
    }()
    
    // Generic Service Provision Method
    func provideService<T>() -> T {
        switch T.self {
        case is TopArtistsServiceProtocol.Type:
            return topArtistsService as! T
        case is TopAlbumsServiceProtocol.Type:
            return topAlbumsService as! T
        case is TopTracksServiceProtocol.Type:
            return topTracksService as! T
        default:
            fatalError("No service found for \(T.self)")
        }
    }
}
