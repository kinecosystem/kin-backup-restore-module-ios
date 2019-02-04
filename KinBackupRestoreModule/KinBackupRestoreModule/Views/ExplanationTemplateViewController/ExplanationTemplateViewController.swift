//
//  ExplanationTemplateViewController.swift
//  KinEcosystem
//
//  Created by Corey Werner on 17/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class ExplanationTemplateViewController: BRViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reminderContainerView: UIView!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    @IBOutlet weak var reminderDescriptionLabel: UILabel!
    @IBOutlet weak var continueButton: RoundButton!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    init() {
        super.init(nibName: "ExplanationTemplateViewController", bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadViewIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kinPrimaryBlue
        continueButton.setTitleColor(.kinPrimaryBlue, for: .normal)
        if #available(iOS 11, *) {
            topSpace.constant = 0.0
            view.layoutIfNeeded()
        }
    }
}


// TODO: move
extension UIColor {
    static let kinPrimaryBlue = UIColor(red: 0, green: 0, blue: 1, alpha: 1)

    @nonobjc class var kinBlueGrey: UIColor {
        return UIColor(red: 92.0 / 255.0, green: 103.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
    }


    @nonobjc class var kinBlueGreyTwo: UIColor {
        return UIColor(red: 120.0 / 255.0, green: 132.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var kinWarning: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 2.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var kinSuccess: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 208.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var kinLightBlueGrey: UIColor {
        return UIColor(red: 215.0 / 255.0, green: 220.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }
}
