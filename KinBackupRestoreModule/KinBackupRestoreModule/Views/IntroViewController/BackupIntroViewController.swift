//
//  BackupIntroViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 16/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

class BackupIntroViewController: ExplanationTemplateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        KinBackupRestoreBI.shared.delegate?.kinBackupWelcomePageViewed()

        imageView.image = UIImage(named: "safeIcon", in: .backupRestore, compatibleWith: nil)
        titleLabel.text = "backup_intro.title".localized()
        descriptionLabel.text = "backup_intro.description".localized()
        continueButton.setTitle("backup_intro.next".localized(), for: .normal)
        reminderContainerView.isHidden = true
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            KinBackupRestoreBI.shared.delegate?.kinBackupWelcomePageBackButtonTapped()
        }
    }
}
