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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard once == false else { return }
        once = true
        login()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login() {
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
                print("Facebook user token: \(user.token!)")
            case .google:
                print("Google user token: \(user.token!)")
            case .native:
                print("Native user email: \(user.email!), password: \(user.password!)")
            }
        }
    }
}

