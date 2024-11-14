//
//  TopAlbumsCoordinator.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopAlbumsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: TopAlbumsViewModel = DependencyInjector.shared.provideViewModel()
        let viewController = TopAlbumsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
