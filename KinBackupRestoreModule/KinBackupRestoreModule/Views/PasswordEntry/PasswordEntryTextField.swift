//
//  PasswordEntryTextField.swift
//  KinBackupRestoreModule
//
//  Created by Corey Werner on 20/02/2019.
//  Copyright © 2019 Kin Foundation. All rights reserved.
//

import UIKit

class PasswordEntryTextField: UITextField {
    public var entryState: PasswordState = .default {
        didSet {
            updateFieldStateStyle()
        }
    }

    private let revealIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 37, height: 15))


    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        revealIcon.addTarget(self, action: #selector(revealPassword), for: .touchDown)
        revealIcon.addTarget(self, action: #selector(hidePassword), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        revealIcon.contentMode = .topLeft
        revealIcon.setImage(UIImage(named: "greyRevealIcon", in: .backupRestore, compatibleWith: nil), for: .normal)
        revealIcon.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -15.0, bottom: 0.0, right: 0.0)

        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 22.0, height: frame.height))
        UIView.performWithoutAnimation {
            rightView = revealIcon
            rightViewMode = .whileEditing
            rightView?.frame = rightViewRect(forBounds: bounds)
        }
        layer.borderWidth = 1.0
        leftView = paddingView
        leftViewMode = .always
        isSecureTextEntry = true
        autocapitalizationType = .none
        autocorrectionType = .no
        updateFieldStateStyle()
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 44
        return size
    }

    // MARK:
    
    private func updateFieldStateStyle() {
        switch entryState {
        case .default:
            layer.borderColor = UIColor.kinGray.cgColor
        case .valid:
            layer.borderColor = UIColor.kinPrimary.cgColor
        case .invalid:
            layer.borderColor = UIColor.kinWarning.cgColor
        }
    }
    
    @objc
    private func revealPassword(_ sender: Any) {
        secureButtonHandler(false)
    }
    
    @objc
    private func hidePassword(_ sender: Any) {
        secureButtonHandler(true)
    }
    
    private func secureButtonHandler(_ secure: Bool) {
        let isFirst = isFirstResponder
        if isFirst {
            resignFirstResponder()
        }
        isSecureTextEntry = secure
        if isFirst {
            becomeFirstResponder()
        }
    }
}

extension PasswordEntryTextField {
    enum PasswordState {
        case `default`
        case valid
        case invalid
    }
}
