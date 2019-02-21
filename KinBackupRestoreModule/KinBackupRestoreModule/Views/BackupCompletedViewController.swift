//
//  BackupCompletedViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 17/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

class BackupCompletedViewController: ExplanationTemplateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupCompletedPageViewed()
        
        navigationItem.hidesBackButton = true

        imageView.image = UIImage(named: "safeIcon", in: .backupRestore, compatibleWith: nil)

        titleLabel.text = "backup_completed.title".localized()
        titleLabel.font = .preferredFont(forTextStyle: .title1)

        descriptionLabel.text = "backup_completed.description".localized()
        descriptionLabel.font = .preferredFont(forTextStyle: .body)

        reminderTitleLabel.text = "reminder.title".localized()
        reminderTitleLabel.font = .preferredFont(forTextStyle: .callout, symbolicTraits: [.traitBold])

        reminderDescriptionLabel.text = "reminder.description".localized()
        reminderDescriptionLabel.font = .preferredFont(forTextStyle: .footnote)

        continueButton.isHidden = true
    }
}
