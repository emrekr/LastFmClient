//
//  DependencyInjector.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//
import UIKit

class DependencyInjector {
    // Singleton instance
    static let shared = DependencyInjector()
    
    private init() {}
    
    //MARK: - Services
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
        if T.self == TopArtistsServiceProtocol.self {
            return topArtistsService as! T
        } else if T.self == TopAlbumsServiceProtocol.self {
            return topAlbumsService as! T
        } else if T.self == TopTracksServiceProtocol.self {
            return topTracksService as! T
        } else {
            fatalError("No service found for \(T.self)")
        }
    }
    
    //MARK: - View Models
    func provideViewModel<T>() -> T {
        switch T.self {
        case is TopArtistsViewModel.Type:
            return TopArtistsViewModel(topArtistsService: provideService()) as! T
        case is TopAlbumsViewModel.Type:
            return TopAlbumsViewModel(topAlbumsService: provideService()) as! T
        case is TopTracksViewModel.Type:
            return TopTracksViewModel(topTracksService: provideService()) as! T
        default:
            fatalError("No ViewModel found for \(T.self)")
        }
    }
    
    //MARK: - Coordinators
    func provideTopArtistsCoordinator(navigationController: UINavigationController) -> TopArtistsCoordinator {
        return TopArtistsCoordinator(navigationController: navigationController)
    }
    
    func provideTopAlbumsCoordinator(navigationController: UINavigationController) -> TopAlbumsCoordinator {
        return TopAlbumsCoordinator(navigationController: navigationController)
    }
    
    func provideTopTracksCoordinator(navigationController: UINavigationController) -> TopTracksCoordinator {
        return TopTracksCoordinator(navigationController: navigationController)
    }
}
