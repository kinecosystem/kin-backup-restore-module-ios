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

        titleLabel.text = "kinecosystem_backup_completed_title".localized()
        titleLabel.font = .preferredFont(forTextStyle: .title1)

        descriptionLabel.text = "kinecosystem_backup_completed_description".localized()
        descriptionLabel.font = .preferredFont(forTextStyle: .body)

        reminderTitleLabel.text = "kinecosystem_backup_reminder_title".localized()
        reminderTitleLabel.font = .preferredFont(forTextStyle: .callout, symbolicTraits: [.traitBold])

        reminderDescriptionLabel.text = "kinecosystem_backup_reminder_description".localized()
        reminderDescriptionLabel.font = .preferredFont(forTextStyle: .footnote)

        continueButton.isHidden = true
    }
}
