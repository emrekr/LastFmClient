//
//  TopItemsSegmentedControl.swift
//  LastFmClient
//
//  Created by Emre Kuru on 16.07.2025.
//

import UIKit

final class TopItemsSegmentedControl: UIView {

    private let stackView = UIStackView().style(SegmentedControlStyles.StackView.defaultStyle)
    private let underlineView = UIView().style(SegmentedControlStyles.Underline.defaultStyle)
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0
    
    private var underlineLeadingConstraint: NSLayoutConstraint?
    private var underlineWidthConstraint: NSLayoutConstraint?


    var didSelectIndex: ((Int) -> Void)?

    private let titles: [String]

    init(frame: CGRect = .zero, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupButtons()
        setupUI()
        selectIndex(0, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .tableViewBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        self.addConstraints("H:|-0-[v0]-0-|", views: stackView)
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: SegmentedControlStyles.Underline.height),
            underlineLeadingConstraint!,
            underlineWidthConstraint!
        ])
    }

    private func setupButtons() {
        for (index, title) in titles.enumerated() {
            let button = createButton(title: title, tag: index)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system).style(SegmentedControlStyles.Button.normal)
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderlinePosition(animated: false)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectIndex(sender.tag, animated: true)
        didSelectIndex?(sender.tag)
    }

    func selectIndex(_ index: Int, animated: Bool) {
        selectedIndex = index
        for (i, button) in buttons.enumerated() {
            let isSelected = i == index
            let style = isSelected
                ? SegmentedControlStyles.Button.selected
                : SegmentedControlStyles.Button.normal
            button.apply(style)
        }
        updateUnderlinePosition(animated: animated)
    }

    private func updateUnderlinePosition(animated: Bool) {
        layoutIfNeeded()

        let selectedButton = buttons[selectedIndex]
        underlineLeadingConstraint?.constant = selectedButton.frame.minX
        underlineWidthConstraint?.constant = selectedButton.frame.width

        if animated {
            UIView.animate(withDuration: SegmentedControlStyles.Underline.animationDuration) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}
