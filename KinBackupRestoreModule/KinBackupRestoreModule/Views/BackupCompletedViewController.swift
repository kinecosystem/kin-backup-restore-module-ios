//
//  BackupCompletedViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 17/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class BackupCompletedViewController: ExplanationTemplateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Kin.track { try BackupCompletedPageViewed() } !!!:
        navigationItem.hidesBackButton = true
        imageView.image = UIImage(named: "safeIcon")
        titleLabel.attributedText = "kinecosystem_backup_completed_title".localized().attributed(28.0, weight: .light, color: .white)
        descriptionLabel.attributedText = "kinecosystem_backup_completed_description".localized().attributed(14.0, weight: .regular, color: .white)
        reminderTitleLabel.attributedText = "kinecosystem_backup_reminder_title".localized().attributed(14.0, weight: .bold, color: .white)
        reminderDescriptionLabel.attributedText = "kinecosystem_backup_reminder_description".localized().attributed(12.0, weight: .regular, color: .white)
        continueButton.isHidden = true
    }
}
