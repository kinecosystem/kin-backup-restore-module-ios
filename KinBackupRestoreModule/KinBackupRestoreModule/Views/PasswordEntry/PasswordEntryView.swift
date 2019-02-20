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
    let confirmStackView = UIStackView()
    let confirmLabel = UILabel()
    let confirmImageView = UIImageView()
    let doneButton = RoundButton()
    let bottomLayoutGuideHeight: NSLayoutConstraint

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        let bottomLayoutView = UIView()
        bottomLayoutGuideHeight = bottomLayoutView.heightAnchor.constraint(equalToConstant: 0)
        bottomLayoutGuideHeight.isActive = true

        super.init(frame: frame)

        backgroundColor = .white

        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 10
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true

        passwordInfo.font = .preferredFont(forTextStyle: .body)
        passwordInfo.numberOfLines = 0
        passwordInfo.textAlignment = .center
        contentView.addArrangedSubview(passwordInfo)

        passwordInput1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addArrangedSubview(passwordInput1)

        passwordInput2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addArrangedSubview(passwordInput2)

        confirmStackView.alignment = .center
        confirmStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(confirmStackView)

        confirmImageView.image = UIImage()
        confirmImageView.highlightedImage = UIImage(named: "rectangle17", in: .backupRestore, compatibleWith: nil)
        confirmImageView.layer.borderWidth = 1
        confirmImageView.layer.borderColor = UIColor.kinBlueGreyTwo.cgColor
        confirmImageView.layer.cornerRadius = 2
        confirmImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        confirmImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        confirmStackView.addArrangedSubview(confirmImageView)

        confirmLabel.font = .preferredFont(forTextStyle: .footnote)
        confirmLabel.textColor = .kinBlueGreyTwo
        confirmLabel.numberOfLines = 0

        confirmStackView.addArrangedSubview(confirmLabel)

        doneButton.isEnabled = false
        contentView.addArrangedSubview(doneButton)

        bottomLayoutView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLayoutView)
        bottomLayoutView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: contentView.spacing).isActive = true
        bottomLayoutView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
