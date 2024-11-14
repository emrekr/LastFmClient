//
//  TopAlbumsViewController.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

class TopAlbumsViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel: TopAlbumsViewModel
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let imageLoader = ImageLoader()
    
    init(viewModel: TopAlbumsViewModel) {
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
            await viewModel.fetchTopAlbums(userId: "emrekr12")
        }
    }
    
    //MARK: - UI setup
    private func setupViews() {
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopAlbumsTableViewCell.self, forCellReuseIdentifier: "TopAlbumsCell")
        
        loadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = loadingIndicator
        
        tableView.rowHeight = 84

        view.addSubview(tableView)
        tableView.fill(.all)
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        viewModel.onFetchTopAlbums = { [weak self] in
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
extension TopAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopAlbumsCell", for: indexPath) as? TopAlbumsTableViewCell else {
            fatalError("Unable to dequeue TopAlbumsTableViewCell")
        }
        let albumViewModel = viewModel.albumAtIndexPath(indexPath: indexPath)
        cell.imageLoader = imageLoader
        cell.configure(with: albumViewModel)
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
                await viewModel.fetchMoreAlbums(userId: "emrekr12")
            }
        }
    }
}
