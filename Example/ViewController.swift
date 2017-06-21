//
//  ViewController.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

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

        let config = LoginConfiguration.default
        config.landingBackgroundImage = #imageLiteral(resourceName: "background")

        let brand = UIImageView(image: #imageLiteral(resourceName: "brand"))
        brand.contentMode = .scaleAspectFit
        brand.snp.makeConstraints { $0.width.equalTo(182) }
        config.landingBrandView = brand

        let controller = LoginViewController(config: config)
        let navigation = UINavigationController(rootViewController: controller)
        present(navigation, animated: true)

        controller.signedIn = { user in
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
    }
}

