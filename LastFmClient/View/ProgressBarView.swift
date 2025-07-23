//
//  ProgressBarView.swift
//  LastFmClient
//
//  Created by Emre Kuru on 22.07.2025.
//

import UIKit

final class ProgressBarView: UIView {

    // MARK: - Subviews

    private let backgroundBar: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewBackground
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fillBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var widthConstraint: NSLayoutConstraint?

    // MARK: - State

    private var currentRatio: CGFloat = 0.0
    private var needsInitialUpdate = true

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(backgroundBar)
        backgroundBar.addSubview(fillBar)

        backgroundBar.fill(.all)
        fillBar.fill(.vertically)
        backgroundBar.addConstraints("H:|-0-[v0]", views: fillBar)

        widthConstraint = fillBar.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true
    }

    // MARK: - Public API

    func setProgress(ratio: CGFloat) {
        currentRatio = max(0.0, min(1.0, ratio))

        if backgroundBar.bounds.width > 0 {
            applyProgress()
            needsInitialUpdate = false
        } else {
            needsInitialUpdate = true
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        if needsInitialUpdate && backgroundBar.bounds.width > 0 {
            applyProgress()
            needsInitialUpdate = false
        }
    }

    private func applyProgress() {
        let width = backgroundBar.bounds.width * currentRatio
        widthConstraint?.constant = width
        layoutIfNeeded()
    }
}
