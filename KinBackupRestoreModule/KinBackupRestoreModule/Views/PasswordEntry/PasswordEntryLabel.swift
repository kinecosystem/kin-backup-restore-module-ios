//
//  PasswordEntryLabel.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 17/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class PasswordEntryLabel: UILabel {
    var instructionsAttributedString: NSAttributedString? {
        didSet {
            syncState()
        }
    }
    var mismatchAttributedString: NSAttributedString? {
        didSet {
            syncState()
        }
    }
    var invalidAttributedString: NSAttributedString? {
        didSet {
            syncState()
        }
    }

    // MARK: State

    var state: State = .instructions {
        didSet {
            syncState()
        }
    }

    private func syncState() {
        switch state {
        case .instructions:
            attributedText = instructionsAttributedString
        case .mismatch:
            attributedText = mismatchAttributedString
        case .invalid:
            attributedText = invalidAttributedString
        }
    }
}

// MARK: - State

extension PasswordEntryLabel {
    enum State {
        case instructions
        case mismatch
        case invalid
    }
}
