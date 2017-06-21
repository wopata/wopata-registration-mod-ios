//
//  SignInViewController.swift
//  login
//
//  Created by Guillaume Bellue on 20/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    let bundle: Bundle? = {
        return nil
        let navigationBundle = Bundle(for: SignInViewController.self)
        let bundleURL = navigationBundle.url(forResource: "Images", withExtension: "bundle")!
        return Bundle(url: bundleURL)!
    }()

    let config: LoginConfiguration

    init(config: LoginConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        self.config = LoginConfiguration.default
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        super.willMove(toParentViewController: parent)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate()
    }

    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.setColors()
            }, completion: nil)
    }

    private func setColors(){
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
    }

    override func loadView() {
        super.loadView()
        setColors()
        view.backgroundColor = UIColor(red: 250.0/255, green: 250.0/255, blue: 250.0/255, alpha: 1)
        title = NSLocalizedString("SignInTitle", comment: "Se connecter")

        let google = buildGoogleButton()
        view.addSubview(google)
        google.snp.makeConstraints {
            $0.left.top.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
        }

        let facebook = buildFacebookButton()
        view.addSubview(facebook)
        facebook.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(google.snp.bottom).offset(12)
        }

        let or = buildOrSeparator()
        view.addSubview(or)
        or.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(facebook.snp.bottom).offset(32)
        }

        let email = EmailField(font: config.font)
        view.addSubview(email)
        email.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(or.snp.bottom).offset(40)
        }

        let pwd = PasswordField(font: config.font)
        view.addSubview(pwd)
        pwd.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(email.snp.bottom).offset(15)
        }

        let button = buildButton()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(pwd.snp.bottom).offset(45)
        }

        let reset = buildResetButton()
        view.addSubview(reset)
        reset.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(button.snp.bottom)
        }

        let footer = buildFooter()
        view.addSubview(footer)
        footer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }

    }

    private func buildGoogleButton() -> UIView {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "google-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        let title = NSLocalizedString("LoginWithGoogle", comment: "Se connecter avec Google")
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

    private func buildFacebookButton() -> UIView {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "facebook-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        let title = NSLocalizedString("LoginWithFacebook", comment: "Se connecter avec Facebook")
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

    private func buildOrSeparator() -> UIView {
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

    private func buildButton() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("LoginButtonTitle", comment: "Se connecter").uppercased(), for: .normal)
        button.backgroundColor = config.ctaBackgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = config.ctaFont.withSize(15)
        button.layer.cornerRadius = 3

        return button
    }

    private func buildResetButton() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("LoginResetTitle", comment: "Mot de passe oublié ?"), for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(white: 0, alpha: 0.5), for: .normal)
        button.titleLabel?.font = config.font.withSize(14)

        return button
    }

    private func buildFooter() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1).cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.backgroundColor = .white

        let attributedString = NSMutableAttributedString(
            string: NSLocalizedString("LoginNoAccount", comment: "Pas encore de compte"),
            attributes: [
                NSForegroundColorAttributeName: UIColor.black,
                NSFontAttributeName: config.font.withSize(15)
            ])
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(
            string: NSLocalizedString("LoginRegister", comment: "Inscription"),
            attributes: [
                NSForegroundColorAttributeName: config.ctaBackgroundColor,
                NSFontAttributeName: config.font.withSize(15).bold(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
            ]))
        let button = UIButton(type: .custom)
        button.setAttributedTitle(attributedString, for: .normal)
        button.setImage(UIImage(named: "info-icon", in: bundle, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        view.addSubview(button)
        button.snp.makeConstraints { $0.edges.equalToSuperview() }

        button.imageEdgeInsets = UIEdgeInsets(top: 22, left: 0, bottom: 23, right: 10)

        return view
    }
}
