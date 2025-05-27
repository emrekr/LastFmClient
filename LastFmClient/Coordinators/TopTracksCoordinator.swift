//
//  TopTracksCoordinator.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopTracksCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: TopTracksViewModel = DependencyInjector.shared.provideViewModel()
        let viewController = TopTracksViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
