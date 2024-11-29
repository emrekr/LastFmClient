//
//  TopItemsViewController.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

protocol TopItemsViewControllerDelegate: AnyObject {
    func didSelectSegment(index: Int, in viewController: TopItemsViewController)
}

class TopItemsViewController: UIViewController {
    weak var delegate: TopItemsViewControllerDelegate?
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Top Artists", "Top Albums", "Top Tracks"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSegmentedControlTarget()
        delegate?.didSelectSegment(index: 0, in: self)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        
        view.addConstraints("H:|-16-[v0]-16-|", views: segmentedControl)
        view.addConstraints("V:|-[v0]", views: segmentedControl)
    }
    
    private func addSegmentedControlTarget() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        delegate?.didSelectSegment(index: sender.selectedSegmentIndex, in: self)
    }
}

extension TopItemsViewController {
    func displayChildNavigationController(_ navController: UINavigationController) {
        if let currentNavController = children.first {
            currentNavController.view.removeFromSuperview()
            currentNavController.removeFromParent()
        }

        addChild(navController)
        view.addSubview(navController.view)
        navController.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.addConstraints("H:|-[v0]-|", views: navController.view)
        self.view.addConstraints("V:[v0]-0-[v1]-|", views: segmentedControl, navController.view)
    
        navController.didMove(toParent: self)
    }
}
