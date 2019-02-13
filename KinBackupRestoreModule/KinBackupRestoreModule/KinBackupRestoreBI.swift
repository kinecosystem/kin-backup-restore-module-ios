//
//  KinBackupRestoreBI.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 06/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import Foundation

final class KinBackupRestoreBI {
    static let shared = KinBackupRestoreBI()
    weak var delegate: KinBackupRestoreBIDelegate?
}

public protocol KinBackupRestoreBIDelegate: NSObjectProtocol {
    func kinBackupStartButtonTapped()
    func kinBackupCompletedPageViewed()
    func kinBackupCreatePasswordPageViewed()
    func kinBackupCreatePasswordBackButtonTapped()
    func kinBackupCreatePasswordNextButtonTapped()
    func kinBackupQrCodeBackButtonTapped()
    func kinBackupQrCodePageViewed()
    func kinBackupQrCodeMyqrcodeButtonTapped()
    func kinBackupQrCodeSendButtonTapped()
    func kinBackupWelcomePageViewed()
    func kinBackupWelcomePageBackButtonTapped()

    func kinRestorePasswordEntryBackButtonTapped()
    func kinRestorePasswordEntryPageViewed()
    func kinRestorePasswordDoneButtonTapped()
    func kinRestoreUploadQrCodePageViewed()
    func kinRestoreUploadQrCodeBackButtonTapped()
    func kinRestoreUploadQrCodeButtonTapped()
    func kinRestoreAreYouSureOkButtonTapped()
    func kinRestoreAreYouSureCancelButtonTapped()
}
