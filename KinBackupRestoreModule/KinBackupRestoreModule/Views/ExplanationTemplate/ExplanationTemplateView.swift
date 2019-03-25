//
//  ExplanationTemplateView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 25/03/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class ExplanationTemplateView: KeyboardAdjustingScrollView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let doneButton = RoundButton()

    // MARK: Lifecycle

    required override init(frame: CGRect) {
        super.init(frame: frame)

//        let imageViewStackView = UIStackView()
//        imageViewStackView.axis = .vertical
//        imageViewStackView.alignment = .center
//        imageViewStackView.spacing = contentView.spacing
//        contentView.addArrangedSubview(imageViewStackView)
//
//        addArrangedVerticalLayoutSubview(to: imageViewStackView, sizeClass: .regular)
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
//        imageViewStackView.addArrangedSubview(imageView)
//        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
//
//        addArrangedVerticalSpaceSubview(to: imageViewStackView, height: 10, sizeClass: .regular)
//
//        let contentStackView = UIStackView()
//        contentStackView.axis = .vertical
//        contentStackView.spacing = contentView.spacing
//        contentView.addArrangedSubview(contentStackView)
//
//        addArrangedVerticalLayoutSubview(to: contentStackView, sizeClass: .compact)
//
//        instructionsLabel.text = "qr.description".localized()
//        instructionsLabel.font = .preferredFont(forTextStyle: .body)
//        instructionsLabel.textColor = .kinGray
//        instructionsLabel.textAlignment = .center
//        instructionsLabel.numberOfLines = 0
//        instructionsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
//        instructionsLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
//        contentStackView.addArrangedSubview(instructionsLabel)
//
//        addArrangedVerticalSpaceSubview(to: contentStackView, height: 10)
//
//        let reminderView = ReminderView()
//        reminderView.tintColor = .kinWarning
//        reminderView.setContentCompressionResistancePriority(.required, for: .vertical)
//        reminderView.setContentHuggingPriority(.required, for: .vertical)
//        contentStackView.addArrangedSubview(reminderView)
//
//        addArrangedVerticalSpaceSubview(to: contentStackView, height: 10)
//
//        confirmControl.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
//        contentStackView.addArrangedSubview(confirmControl)
//
//        let confirmStackView = UIStackView()
//        confirmStackView.translatesAutoresizingMaskIntoConstraints = false
//        confirmStackView.axis = .horizontal
//        confirmStackView.spacing = contentView.spacing
//        confirmStackView.alignment = .center
//        confirmStackView.isUserInteractionEnabled = false
//        confirmControl.addSubview(confirmStackView)
//        confirmStackView.topAnchor.constraint(equalTo: confirmControl.topAnchor).isActive = true
//        confirmStackView.leadingAnchor.constraint(greaterThanOrEqualTo: confirmControl.leadingAnchor).isActive = true
//        confirmStackView.bottomAnchor.constraint(equalTo: confirmControl.bottomAnchor).isActive = true
//        confirmStackView.trailingAnchor.constraint(lessThanOrEqualTo: confirmControl.trailingAnchor).isActive = true
//        confirmStackView.centerXAnchor.constraint(equalTo: confirmControl.centerXAnchor).isActive = true
//
//        confirmImageView.tintColor = .kinPrimary
//        confirmImageView.highlightedImage = UIImage(named: "Checkmark", in: .backupRestore, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//        confirmImageView.setContentHuggingPriority(.required, for: .horizontal)
//        confirmImageView.layer.borderColor = UIColor.kinGray.cgColor
//        confirmImageView.layer.borderWidth = 1
//        confirmImageView.layer.cornerRadius = 4
//        confirmImageView.layer.masksToBounds = true
//        confirmStackView.addArrangedSubview(confirmImageView)
//
//        let confirmLabel = UILabel()
//        confirmLabel.text = "qr.saved".localized()
//        confirmLabel.font = .preferredFont(forTextStyle: .body)
//        confirmLabel.textColor = .kinGray
//        confirmStackView.addArrangedSubview(confirmLabel)
//
//        addArrangedVerticalSpaceSubview(to: contentStackView)
//
//        doneButton.appearance = .blue
//        doneButton.setTitle("qr.save".localized(), for: .normal)
//        doneButton.setTitle("generic.next".localized(), for: .selected)
//        doneButton.setContentCompressionResistancePriority(.required, for: .vertical)
//        doneButton.setContentHuggingPriority(.required, for: .vertical)
//        contentStackView.addArrangedSubview(doneButton)
//
//        addArrangedVerticalLayoutSubview(to: contentStackView, sizeClass: .compact)
//        addArrangedVerticalLayoutSubview(to: contentStackView, sizeClass: .regular)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
