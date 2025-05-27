//
//  TopArtistsCoordinator.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

class TopArtistsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: TopArtistsViewModel = DependencyInjector.shared.provideViewModel()
        let viewController = TopArtistsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
