//
//  Coordinator.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
