//
//  QRView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 20/03/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class QRView: KeyboardAdjustingScrollView {
    let imageView = UIImageView()
    let instructionsLabel = UILabel()
    let reminderLabel = UILabel()
    private let reminderView = ReminderView()
    let doneButton = RoundButton()

    private var regularConstraints: [NSLayoutConstraint] = []

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

        let imageViewStackView = UIStackView()
        imageViewStackView.axis = .vertical
        imageViewStackView.alignment = .center
        imageViewStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(imageViewStackView)

        addArrangedVerticalLayoutSubview(to: imageViewStackView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageViewStackView.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        regularConstraints += [
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]

        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = contentView.spacing
        contentView.addArrangedSubview(contentStackView)

        addArrangedVerticalSpaceSubview(to: contentStackView)

        instructionsLabel.font = .preferredFont(forTextStyle: .body)
        instructionsLabel.textColor = .kinBlueGreyTwo
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(instructionsLabel)

        reminderView.tintColor = .kinWarning
        reminderView.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(reminderView)

        addArrangedVerticalSpaceSubview(to: contentStackView)

        doneButton.appearance = .blue
        doneButton.setContentCompressionResistancePriority(.required, for: .vertical)
        doneButton.setContentHuggingPriority(.required, for: .vertical)
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

            NSLayoutConstraint.deactivate(regularConstraints)
        }
        else {
            contentView.axis = .vertical
            contentView.distribution = .fill

            NSLayoutConstraint.activate(regularConstraints)
        }
    }
}
