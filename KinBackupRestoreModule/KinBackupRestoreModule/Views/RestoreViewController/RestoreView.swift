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
    let instructionsLabel = UILabel()
    let passwordInput = PasswordEntryTextField()
    let doneButton = RoundButton()

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

        addArrangedVerticalLayoutSubview(to: contentView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(imageView)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.font = .preferredFont(forTextStyle: .body)
        instructionsLabel.textColor = .kinBlueGreyTwo
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(instructionsLabel)

        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.isSecureTextEntry = true
        passwordInput.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(passwordInput)

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addArrangedSubview(doneButton)

        addArrangedVerticalLayoutSubview(to: contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
