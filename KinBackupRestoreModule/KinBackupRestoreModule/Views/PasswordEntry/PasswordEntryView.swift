//
//  PasswordEntryView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 19/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class PasswordEntryView: UIScrollView {
    let passwordInfo = PasswordEntryLabel()
    let passwordInput1 = PasswordEntryTextField()
    let passwordInput2 = PasswordEntryTextField()
    private let confirmStackView = UIStackView()
    let confirmLabel = UILabel()
    private let confirmImageView = UIImageView()
    let doneButton = RoundButton()

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

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        let contentLayoutGuide = UILayoutGuide()
        addLayoutGuide(contentLayoutGuide)
        contentLayoutGuide.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        contentLayoutGuideBottomConstraint = contentLayoutGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        contentLayoutGuideBottomConstraint?.isActive = true

        let contentView = UIStackView()
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

        addArrangedVerticalLayoutSubview(to: contentView)

        passwordInfo.font = .preferredFont(forTextStyle: .body)
        passwordInfo.numberOfLines = 0
        passwordInfo.textAlignment = .center
        passwordInfo.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordInfo)

        addArrangedVerticalLayoutSubview(to: contentView)

        passwordInput1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordInput1.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordInput1)

        passwordInput2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordInput2.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordInput2)

        confirmStackView.alignment = .center
        confirmStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(confirmStackView)

        confirmImageView.image = UIImage()
        confirmImageView.highlightedImage = UIImage(named: "rectangle17", in: .backupRestore, compatibleWith: nil)
        confirmImageView.layer.borderWidth = 1
        confirmImageView.layer.borderColor = UIColor.kinBlueGreyTwo.cgColor
        confirmImageView.layer.cornerRadius = 2
        confirmImageView.setContentCompressionResistancePriority(.required, for: .vertical)
        confirmStackView.addArrangedSubview(confirmImageView)
        confirmImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        confirmImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        confirmLabel.font = .preferredFont(forTextStyle: .footnote)
        confirmLabel.textColor = .kinBlueGreyTwo
        confirmLabel.numberOfLines = 0
        confirmLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        confirmStackView.addArrangedSubview(confirmLabel)

        addArrangedVerticalLayoutSubview(to: contentView)

        doneButton.isEnabled = false
        doneButton.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(doneButton)

        addArrangedVerticalLayoutSubview(to: contentView)

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

    // MARK: Layout

    private var firstVerticalLayoutView: UIView?

    private func addArrangedVerticalLayoutSubview(to stackView: UIStackView) {
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

    // MARK: Interaction

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if touches.first?.view == confirmStackView,
            let point = touches.first?.location(in: self),
            hitTest(point, with: event) == confirmStackView
        {
            confirmImageView.isHighlighted = !confirmImageView.isHighlighted
            updateDoneButton()
        }
    }

    // MARK: View Updates

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        updateDoneButton()
    }

    func updateDoneButton() {
        doneButton.isEnabled = passwordInput1.hasText && passwordInput2.hasText && confirmImageView.isHighlighted
    }
}
