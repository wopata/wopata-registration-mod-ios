//
//  ButtonBuilder.swift
//  login
//
//  Created by Guillaume Bellue on 21/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

class ButtonBuilder {

    var config: WopataLoginConfiguration!

    static let shared: ButtonBuilder = {
        return ButtonBuilder()
    }()

    let bundle: Bundle? = {
        return nil
//        let navigationBundle = Bundle(for: SignInViewController.self)
//        let bundleURL = navigationBundle.url(forResource: "Images", withExtension: "bundle")!
//        return Bundle(url: bundleURL)!
    }()

    func googleButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "google-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: config.font.withSize(15)
            ])
        if let range = title.range(of: "Google") {
            let nsrange = title.nsRange(from: range)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), range: nsrange)
        }
        button.setAttributedTitle(attributedString, for: .normal)

        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 17, right: 0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor

        return button
    }

    func facebookButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "facebook-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: config.font.withSize(15)
            ])
        if let range = title.range(of: "Facebook") {
            let nsrange = title.nsRange(from: range)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold), range: nsrange)
        }
        button.setAttributedTitle(attributedString, for: .normal)

        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 17, right: 10)
        button.backgroundColor = UIColor(red: 59.0/255, green: 89.0/255, blue: 152.0/255, alpha: 1)
        button.layer.cornerRadius = 3

        return button
    }

    func orSeparator() -> UIView {
        let container = UIView()

        let line1 = UIView()
        line1.backgroundColor = UIColor(white: 0, alpha: 0.15)
        container.addSubview(line1)
        let line2 = UIView()
        line2.backgroundColor = UIColor(white: 0, alpha: 0.15)
        container.addSubview(line2)

        let label = UILabel()
        label.text = NSLocalizedString("OR", comment: "ou").uppercased()
        label.textColor = UIColor(white: 0, alpha: 0.5)
        label.font = config.font.withSize(12)
        container.addSubview(label)

        line1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.left.equalToSuperview()
            $0.right.equalTo(label.snp.left).offset(-14)
        }
        line2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.right.equalToSuperview()
            $0.left.equalTo(label.snp.right).offset(14)
        }
        label.snp.makeConstraints {
            $0.centerX.top.bottom.equalToSuperview()
        }

        return container
    }

    func mainButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title.uppercased(), for: .normal)
        button.backgroundColor = config.ctaBackgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = config.ctaFont.withSize(15)
        button.layer.cornerRadius = 3

        return button
    }

    func resetButton() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("LoginResetTitle", comment: "Mot de passe oublié ?"), for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
        button.titleLabel?.font = config.font.withSize(14)

        return button
    }

    func footer(title1: String, title2: String) -> UIButton {
        let attributedString = NSMutableAttributedString(
            string: title1,
            attributes: [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: config.font.withSize(15)
            ])
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(
            string: title2,
            attributes: [
                NSForegroundColorAttributeName: config.ctaBackgroundColor,
                NSFontAttributeName: config.font.withSize(15).bold(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
            ]))

        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setAttributedTitle(attributedString, for: .normal)
        button.setImage(UIImage(named: "info-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        button.layer.shadowColor = UIColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1).cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero

        button.imageEdgeInsets = UIEdgeInsets(top: 22, left: 0, bottom: 23, right: 10)
        
        return button
    }
}
