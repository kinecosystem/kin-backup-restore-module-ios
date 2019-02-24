//
//  KeyboardAdjustingScrollView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 24/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class KeyboardAdjustingScrollView: UIScrollView {
    let contentView = UIStackView()

    private var contentLayoutGuideBottomConstraint: NSLayoutConstraint?
    private var bottomLayoutHeightConstraint: NSLayoutConstraint?
    var bottomLayoutHeight: CGFloat = 0 {
        didSet {
            let bottomOffset = layoutMargins.left
            let bottomHeight = bottomLayoutHeight + bottomOffset

            contentLayoutGuideBottomConstraint?.constant = -bottomHeight
            bottomLayoutHeightConstraint?.constant = bottomHeight
        }
    }

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        backgroundColor = .white

        let contentLayoutGuide = UILayoutGuide()
        addLayoutGuide(contentLayoutGuide)
        contentLayoutGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        contentLayoutGuideBottomConstraint = contentLayoutGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        contentLayoutGuideBottomConstraint?.isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 10
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(lessThanOrEqualTo: contentLayoutGuide.heightAnchor)
        contentViewHeightConstraint.priority = .defaultHigh
        contentViewHeightConstraint.isActive = true

        let bottomLayoutView = UIView()
        bottomLayoutView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLayoutView)
        bottomLayoutView.topAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomLayoutView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLayoutHeightConstraint = bottomLayoutView.heightAnchor.constraint(equalToConstant: 0)
        bottomLayoutHeightConstraint?.isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Layout

    private var firstVerticalLayoutView: UIView?

    func addArrangedVerticalLayoutSubview(to stackView: UIStackView) {
        let layoutView = UIView()
        stackView.addArrangedSubview(layoutView)

        if let firstVerticalLayoutView = firstVerticalLayoutView {
            layoutView.heightAnchor.constraint(equalTo: firstVerticalLayoutView.heightAnchor).isActive = true
        }
        else {
            firstVerticalLayoutView = layoutView

            let layoutViewHeightConstraint = layoutView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
            layoutViewHeightConstraint.priority = .defaultLow
            layoutViewHeightConstraint.isActive = true
        }
    }

    // MARK: Keyboard

    @objc
    private func keyboardWillChangeFrameNotification(_ notification: Notification) {
        let frame = notification.endFrame

        guard frame != .null else {
            return
        }

        // iPhone X keyboard has a height when it's not displayed.
        let bottomHeight = max(0, bounds.height - frame.origin.y - layoutMargins.bottom)

        scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bottomHeight, right: 0)

        let isViewOnScreen = layer.presentation() != nil

        if isViewOnScreen {
            UIView.animate(withDuration: notification.duration, delay: 0, options: notification.animationOptions, animations: { [weak self] in
                self?.bottomLayoutHeight = bottomHeight
                self?.layoutIfNeeded()
            })
        }
        else {
            bottomLayoutHeight = bottomHeight
        }
    }
}
