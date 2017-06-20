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

        let navigation = UINavigationController(rootViewController: LoginViewController(config: config))
        present(navigation, animated: true)
    }
}

