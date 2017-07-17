//
//  RestViewController.swift
//  Pods
//
//  Created by Guillaume Bellue on 23/06/2017.
//
//

import UIKit

class ResetViewController: SHKeyboardViewController {
    let config = WopataLogin.shared.config
    let signedIn = WopataLogin.shared.signedIn
    let signedUp = WopataLogin.shared.signedUp
    let reset = WopataLogin.shared.reset

    var emailValue: String? { didSet { updateButton() } }
    var button: UIButton!

    var scrollView: UIScrollView!
    var emailField: InputField!

    override func viewDidLoad() {
        super.viewDidLoad()

//        registerKeyboardNotifications(for: scrollView)
        updateButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = localize("reset_title")
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
            $0.top.equalTo(35)
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        emailField.valueChanged = { self.emailValue = $0 }

        button = ButtonBuilder.shared.mainButton(title: localize("reset_button_title"))
        button.addTarget(self, action: #selector(resetWithEmail), for: .touchUpInside)
        container.addSubview(button)
        button.snp.makeConstraints {
            $0.left.equalTo(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(emailField.snp.bottom).offset(40)
        }
    }

    private func updateButton() {
        let enabled = emailValue?.isEmpty == false
        button.isEnabled = enabled
        button.alpha = enabled ? 1 : 0.7
    }

}

extension ResetViewController: ErrorHandler {
    func addError(field: WopataLoginField, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ResetViewController {
    func resetWithEmail() {
        self.reset?(User(source: .native, email: emailValue))
    }

    func signIn() {
        _ = navigationController?.popViewController(animated: true)
    }
}
