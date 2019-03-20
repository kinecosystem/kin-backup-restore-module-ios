//
//  ReminderView.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 20/03/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class ReminderView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.spacing = 8
        topStackView.alignment = .center
        stackView.addArrangedSubview(topStackView)

        imageView.tintAdjustmentMode = .normal
        imageView.image = UIImage(named: "whiteFlagIcon", in: .backupRestore, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        topStackView.addArrangedSubview(imageView)

        titleLabel.text = "reminder.title".localized()
        titleLabel.font = .preferredFont(forTextStyle: .callout, symbolicTraits: [.traitBold])
        topStackView.addArrangedSubview(titleLabel)

        detailLabel.text = "reminder.description".localized()
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        stackView.addArrangedSubview(detailLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Appearance

    override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            titleLabel.textColor = tintColor
            detailLabel.textColor = tintColor
        }
    }
}
