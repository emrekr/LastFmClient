//
//  TopItemsCoordinator.swift
//  LastFmClient
//
//  Created by Emre Kuru on 21.11.2024.
//

import UIKit

class TopItemsCoordinator: Coordinator {
    var navigationController: UINavigationController

    private lazy var topAlbumsCoordinator: TopAlbumsCoordinator = {
        let navController = UINavigationController()
        let coordinator = DependencyInjector.shared.provideTopAlbumsCoordinator(navigationController: navController)
        coordinator.start()
        return coordinator
    }()
    private lazy var topArtistsCoordinator: TopArtistsCoordinator = {
        let navController = UINavigationController()
        let coordinator = DependencyInjector.shared.provideTopArtistsCoordinator(navigationController: navController)
        coordinator.start()
        return coordinator
    }()
    private lazy var topTracksCoordinator: TopTracksCoordinator = {
        let navController = UINavigationController()
        let coordinator = DependencyInjector.shared.provideTopTracksCoordinator(navigationController: navController)
        coordinator.start()
        return coordinator
    }()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = TopItemsViewController()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension TopItemsCoordinator: TopItemsViewControllerDelegate {
    func didSelectSegment(index: Int, in viewController: TopItemsViewController) {
        switch index {
        case 0:
            viewController.displayChildNavigationController(topAlbumsCoordinator.navigationController)
        case 1:
            viewController.displayChildNavigationController(topArtistsCoordinator.navigationController)
        case 2:
            viewController.displayChildNavigationController(topTracksCoordinator.navigationController)
        default:
            break
        }
    }
}

