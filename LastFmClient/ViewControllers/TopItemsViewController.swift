//
//  TopItemsViewController.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

enum TopItems: String, CaseIterable {
    case topArtists = "Top Artists"
    case topAlbums = "Top Albums"
    case topTracks = "Top Tracks"
}

protocol TopItemsViewControllerDelegate: AnyObject {
    func didSelectSegment(index: Int, in viewController: TopItemsViewController)
}

class TopItemsViewController: UIViewController {
    weak var delegate: TopItemsViewControllerDelegate?
    
    private lazy var segmentedControl: TopItemsSegmentedControl = {
        let segmentedControl = TopItemsSegmentedControl(titles: TopItems.allCases.map({$0.rawValue}))
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var userInfoView = UserInfoView(viewModel: userInfoViewModel)
    
    private let userInfoViewModel: UserInfoViewModel

    init(userInfoViewModel: UserInfoViewModel) {
        self.userInfoViewModel = userInfoViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSegmentedControlTarget()
        delegate?.didSelectSegment(index: 0, in: self)
    }
    
    private func setupUI() {
        view.backgroundColor = .tableViewBackground
        
        view.addSubview(userInfoView)
        view.addSubview(segmentedControl)
        
        view.addConstraints("H:|-16-[v0]-16-|", views: userInfoView)
        view.addConstraints("H:|-16-[v0]-16-|", views: segmentedControl)
        view.addConstraints("V:|-[v0]-8-[v1(48)]", views: userInfoView, segmentedControl)
    }
    
    private func addSegmentedControlTarget() {
        segmentedControl.didSelectIndex = { [weak self] index in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.didSelectSegment(index: index, in: weakSelf)
        }
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
