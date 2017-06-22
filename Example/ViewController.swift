//
//  ViewController.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import KVNProgress

class ViewController: UIViewController {
    var once = false
    @IBOutlet weak var signedIn: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard once == false else { return }
        once = true
        login()
    }

    @IBAction func login() {
        signedIn.text = nil

        let config = Login.shared.config
        config.landingBackgroundImage = #imageLiteral(resourceName: "background")

        let brand = UIImageView(image: #imageLiteral(resourceName: "brand"))
        brand.contentMode = .scaleAspectFit
        brand.snp.makeConstraints { $0.width.equalTo(182) }
        config.landingBrandView = brand
        Login.shared.config = config

        Login.shared.signedIn = { user in
            switch user.source {
            case .facebook:
                self.signedIn.text = "Facebook user token:\n\(user.token!)"
            case .google:
                self.signedIn.text = "Google user token:\n\(user.token!)"
            case .native:
                self.signedIn.text = "Native user\nemail: \(user.email!)\npassword: \(user.password!)"
            }
            self.signedIn.isHidden = false
            self.dismiss(animated: true)
        }
        Login.shared.signedUp = { user in
            KVNProgress.show(withStatus: "Faking sending user data to server")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                KVNProgress.dismiss()
                switch user.source {
                case .facebook:
                    Login.shared.addError(field: .facebook, message: "Une erreur est intervenue, veuillez réessayer ultérieurement")
                case .google:
                    Login.shared.addError(field: .google, message: "Une erreur est intervenue, veuillez réessayer ultérieurement")
                case .native:
                    Login.shared.addError(field: .email, message: "Cet email est déjà pris")
                    Login.shared.addError(field: .password, message: "Le mot de passe est trop court")
                }
            }
        }

        let navigation = UINavigationController(rootViewController: Login.shared.mainController)
        present(navigation, animated: true)
    }
}

