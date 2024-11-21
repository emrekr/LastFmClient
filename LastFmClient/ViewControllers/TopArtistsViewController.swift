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
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
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
    
    //MARK: - UI setup
    private func setupViews() {
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopArtistTableViewCell.self, forCellReuseIdentifier: "TopArtistsCell")
        
        loadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = loadingIndicator
        
        tableView.contentInsetAdjustmentBehavior = .never

        view.addSubview(tableView)
        tableView.fill(.all)
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        viewModel.onFetchTopArtists = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showErrorAlert(with: error.message)
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Error handling
    private func showErrorAlert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITableView Delegate and Data Source
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
    
    // Detect when the user scrolls to the bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let threshold = contentHeight - frameHeight * 1.5 // Adjust threshold as needed

        if position > threshold {
            Task {
                await viewModel.fetchMoreArtists(userId: "emrekr12")
            }
        }
    }
}
