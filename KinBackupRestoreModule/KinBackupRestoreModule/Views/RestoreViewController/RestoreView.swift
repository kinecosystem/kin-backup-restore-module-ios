//
//  RestoreView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 24/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class RestoreView: KeyboardAdjustingScrollView {
    let imageView = UIImageView()
    private var imageViewWidthConstraint: NSLayoutConstraint?
    let instructionsLabel = UILabel()
    let passwordInput = PasswordEntryTextField()
    let doneButton = ConfirmButton()

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

        let imageViewStackView = UIStackView()
        imageViewStackView.axis = .vertical
        imageViewStackView.alignment = .center
        imageViewStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(imageViewStackView)

        addArrangedVerticalLayoutSubview(to: imageViewStackView)

        imageViewStackView.addArrangedSubview(imageView)
        imageViewWidthConstraint = imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(contentStackView)

        instructionsLabel.font = .preferredFont(forTextStyle: .body)
        instructionsLabel.textColor = .kinBlueGreyTwo
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(instructionsLabel)

        addArrangedVerticalSpaceSubview(to: contentStackView)

        passwordInput.isSecureTextEntry = true
        passwordInput.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(passwordInput)

        doneButton.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(doneButton)

        addArrangedVerticalLayoutSubview(to: contentStackView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.verticalSizeClass == .compact {
            contentView.axis = .horizontal
            contentView.distribution = .fillEqually
            
            imageViewWidthConstraint?.isActive = false
        }
        else {
            contentView.axis = .vertical
            contentView.distribution = .fill

            imageViewWidthConstraint?.isActive = true
        }
    }
}
