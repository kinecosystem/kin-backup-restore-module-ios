//
//  PasswordEntryView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 19/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class PasswordEntryView: KeyboardAdjustingScrollView {
    let passwordInfoLabel = PasswordEntryLabel()
    let passwordTextField = PasswordEntryTextField()
    let passwordConfirmTextField = PasswordEntryTextField()
    private let confirmStackView = UIStackView()
    let confirmLabel = UILabel()
    private let confirmImageView = UIImageView()
    let doneButton = RoundButton()

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

        addArrangedVerticalLayoutSubview(to: contentView)

        passwordInfoLabel.font = .preferredFont(forTextStyle: .body)
        passwordInfoLabel.numberOfLines = 0
        passwordInfoLabel.textAlignment = .center
        passwordInfoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordInfoLabel)

        addArrangedVerticalLayoutSubview(to: contentView)

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordTextField)

        passwordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordConfirmTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordConfirmTextField)

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
        doneButton.isEnabled = passwordTextField.hasText && passwordConfirmTextField.hasText && confirmImageView.isHighlighted
    }
}
