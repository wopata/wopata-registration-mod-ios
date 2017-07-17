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

class SignInViewController: SHKeyboardViewController {
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

    override func willMove(toParentViewController parent: UIViewController?) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        super.willMove(toParentViewController: parent)
    }

    override func viewWillAppear(_ animated: Bool) {
        title = localize("sign_in_title")
        setColors()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }

    private func setColors() {
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
        ButtonBuilder.shared.config = config

        scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let main = UIView()
        scrollView.addSubview(main)
        main.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(view)
        }

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        main.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.left.equalTo(35)
            $0.centerX.equalToSuperview()
        }

        if config.signinModes.contains(.google) {
            let google = ButtonBuilder.shared.googleButton(title: localize("login_with_google"))
            google.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
            google.snp.makeConstraints {
                $0.height.equalTo(45)
            }
            stack.addArrangedSubview(google)
        }

        if config.signinModes.contains(.facebook) {
            let facebook = ButtonBuilder.shared.facebookButton(title: localize("login_with_facebook"))
            facebook.addTarget(self, action: #selector(loginWithFacebook), for: .touchUpInside)
            facebook.snp.makeConstraints {
                $0.height.equalTo(45)
            }
            stack.addArrangedSubview(facebook)
        }

        if config.signinModes.contains(.email) {
            if config.signinModes.contains(.google) || config.signinModes.contains(.facebook) {
                let or = ButtonBuilder.shared.orSeparator()
                let container = UIView()
                container.addSubview(or)
                or.snp.makeConstraints {
                    $0.top.equalTo(23)
                    $0.bottom.left.right.equalToSuperview()
                }
                stack.addArrangedSubview(container)
            }

            let form = UIView()
            emailField = EmailField(font: config.font)
            emailField.tintColor = config.ctaBackgroundColor
            form.addSubview(emailField)
            emailField.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(0)
            }
            emailField.valueChanged = { self.emailValue = $0 }

            pwdField = PasswordField(font: config.font)
            pwdField.tintColor = config.ctaBackgroundColor
            form.addSubview(pwdField)
            pwdField.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(emailField.snp.bottom).offset(12)
            }
            pwdField.valueChanged = { self.pwdValue = $0 }
            emailField.returnKeyPressed = { _ = self.pwdField.becomeFirstResponder() }

            button = ButtonBuilder.shared.mainButton(title: localize("login_button_title"))
            button.addTarget(self, action: #selector(loginWithEmail), for: .touchUpInside)
            form.addSubview(button)
            button.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(45)
                $0.top.equalTo(pwdField.snp.bottom).offset(40)
            }

            let reset = ButtonBuilder.shared.resetButton()
            reset.addTarget(self, action: #selector(resetEmail), for: .touchUpInside)
            form.addSubview(reset)
            reset.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(45)
                $0.top.equalTo(button.snp.bottom)
                $0.bottom.equalToSuperview()
            }
            stack.addArrangedSubview(form)
        }

        let footer = ButtonBuilder.shared.footer(title1: localize("login_no_account"), title2: localize("login_register"))
        footer.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        main.addSubview(footer)
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

    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        if config.signinModes.contains(.google) && config.signinModes.contains(.facebook) {
            scrollView.contentOffset = CGPoint(x: 0, y: 190)
        } else if config.signinModes.contains(.google) || config.signinModes.contains(.facebook) {
            scrollView.contentOffset = CGPoint(x: 0, y: 140)
        }
    }
}

extension SignInViewController: ErrorHandler {
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

extension SignInViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func loginWithFacebook() {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: config.facebookPermissions, from: self) { result, error in
            guard let result = result, error == nil, !result.isCancelled else { return }
            self.signedIn?(User(source: .facebook, token: FBSDKAccessToken.current().tokenString))
        }
    }

    func loginWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func loginWithEmail() {
        self.signedIn?(User(source: .native, email: emailValue, password: pwdValue))
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { return }
        signedIn?(User(source: .google, token: user.authentication.idToken))
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        // uh... nothing?
    }

    func signUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

    func resetEmail() {
        navigationController?.pushViewController(ResetViewController(), animated: true)
    }
}
