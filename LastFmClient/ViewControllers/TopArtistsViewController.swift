//
//  TopArtistsViewController.swift
//  LastFmClient
//
//  Created by Emre Kuru on 13.11.2024.
//

import UIKit

class TopArtistsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel: TopArtistsViewModel
    
    init(viewModel: TopArtistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        Task {
            await viewModel.fetchTopArtists(userId: "emrekr12")
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopArtistTableViewCell.self, forCellReuseIdentifier: "TopArtistsCell")

        view.addSubview(tableView)
        tableView.fill(.all)
    }
    
    private func setupBindings() {
        viewModel.onFetchTopArtists = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            print(error)
        }
    }
    

}

extension TopArtistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopArtistsCell", for: indexPath) as! TopArtistTableViewCell
        let artistViewModel = viewModel.artistAtIndexPath(indexPath: indexPath)
        cell.configure(with: artistViewModel)
        return cell
    }
}
