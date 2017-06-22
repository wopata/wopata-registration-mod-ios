//
//  SignInViewController.swift
//  login
//
//  Created by Guillaume Bellue on 20/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import SnapKit

import FBSDKLoginKit
import FBSDKCoreKit

import GoogleSignIn

class SignUpViewController: SHKeyboardViewController {
    let config = WopataLogin.shared.config
    let signedIn = WopataLogin.shared.signedIn
    let signedUp = WopataLogin.shared.signedUp

    var emailValue: String? { didSet { updateButton() } }
    var pwdValue: String? { didSet { updateButton() } }
    var button: UIButton!

    var scrollView: UIScrollView!
    var emailField: InputField!
    var pwdField: InputField!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerKeyboardNotifications(for: scrollView)
        updateButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = NSLocalizedString("SignUpTitle", comment: "S'inscrire")
    }

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor(red: 250.0/255, green: 250.0/255, blue: 250.0/255, alpha: 1)
        ButtonBuilder.shared.config = config

        scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let container = UIView()
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(view)
        }

        emailField = EmailField(font: config.font)
        emailField.tintColor = config.ctaBackgroundColor
        container.addSubview(emailField)
        emailField.snp.makeConstraints {
            $0.left.top.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        emailField.valueChanged = { self.emailValue = $0 }

        pwdField = PasswordField(font: config.font)
        pwdField.tintColor = config.ctaBackgroundColor
        container.addSubview(pwdField)
        pwdField.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailField.snp.bottom).offset(12)
        }
        pwdField.valueChanged = { self.pwdValue = $0 }
        emailField.returnKeyPressed = { _ = self.pwdField.becomeFirstResponder() }

        button = ButtonBuilder.shared.mainButton(title: NSLocalizedString("SignupButtonTitle", comment: "S'inscrire"))
        button.addTarget(self, action: #selector(signupWithEmail), for: .touchUpInside)
        container.addSubview(button)
        button.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(pwdField.snp.bottom).offset(40)
        }

        let or = ButtonBuilder.shared.orSeparator()
        container.addSubview(or)
        or.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(button.snp.bottom).offset(35)
        }

        let google = ButtonBuilder.shared.googleButton(title: NSLocalizedString("SignupWithGoogle", comment: "Se connecter avec Google"))
        google.addTarget(self, action: #selector(signupWithGoogle), for: .touchUpInside)
        container.addSubview(google)
        google.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(or.snp.bottom).offset(35)
        }

        let facebook = ButtonBuilder.shared.facebookButton(title: NSLocalizedString("SignupWithFacebook", comment: "Se connecter avec Facebook"))
        facebook.addTarget(self, action: #selector(signupWithFacebook), for: .touchUpInside)
        container.addSubview(facebook)
        facebook.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(google.snp.bottom).offset(12)
        }

        let footer = ButtonBuilder.shared.footer(title1: NSLocalizedString("SignupWithAccount", comment: "Déjà un compte"), title2: NSLocalizedString("SignupConnect", comment: "Connexion"))
        footer.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        container.addSubview(footer)
        footer.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

    private func updateButton() {
        let enabled = emailValue?.isEmpty == false && pwdValue?.isEmpty == false
        button.isEnabled = enabled
        button.alpha = enabled ? 1 : 0.7
    }
}

extension SignUpViewController: ErrorHandler {
    func addError(field: WopataLoginField, message: String) {
        switch field {
        case .email:
            emailValue = nil
            emailField.addError(error: message)
        case .password:
            pwdValue = nil
            pwdField.addError(error: message)
        default:
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension SignUpViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func signupWithFacebook() {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { result, error in
            guard let result = result, error == nil, !result.isCancelled else { return }
            self.signedUp?(User(source: .facebook, token: FBSDKAccessToken.current().tokenString))
        }
    }

    func signupWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func signupWithEmail() {
        self.signedUp?(User(source: .native, email: emailValue, password: pwdValue))
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { return }
        signedUp?(User(source: .google, token: user.authentication.idToken))
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        // uh... nothing?
    }

    func signIn() {
        _ = navigationController?.popViewController(animated: true)
    }
}
