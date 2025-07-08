//
//  UserInfoView.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

import UIKit

final class UserInfoView: UIView {
    private let viewModel: UserInfoViewModel

    private let scrobblesLabel = UserInfoLabel()
    private let artistLabel = UserInfoLabel()
    private let albumLabel = UserInfoLabel()
    private let trackLabel = UserInfoLabel()

    init(viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        Task {
            try? await viewModel.fetchUserInfo(userId: "emrekr12")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [scrobblesLabel, artistLabel, albumLabel, trackLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        self.addConstraintsToSubviews("H:|-10-[v0]-10-|")
        self.addConstraintsToSubviews("V:|-[v0]-|")
    }

    private func bindViewModel() {
        viewModel.onUserInfoUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.scrobblesLabel.text = "Scrobbles\n\(self.viewModel.scrobbles.formatted)"
                self.artistLabel.text = "Artists\n\(self.viewModel.artistCount.formatted)"
                self.albumLabel.text = "Albums\n\(self.viewModel.albumCount.formatted)"
                self.trackLabel.text = "Tracks\n\(self.viewModel.trackCount.formatted)"
            }
        }
    }
}
