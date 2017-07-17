//
//  LoginViewController.swift
//  login
//
//  Created by Guillaume Bellue on 20/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import SnapKit

// Landing View Controller
class LoginViewController: UIViewController {
    let config = WopataLogin.shared.config

    var backgroundImage: UIImageView!
    var logoContainer: UIView!
    var text: UILabel!

    override func loadView() {
        super.loadView()
        setupNavigation()

        backgroundImage = UIImageView(image: config.landingBackgroundImage)
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }

        logoContainer = UIView()
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints {
            $0.top.equalTo(80)
            $0.left.greaterThanOrEqualTo(35)
            $0.centerX.equalToSuperview()
        }

        let button = UIButton(type: .custom)
        button.backgroundColor = config.ctaBackgroundColor
        button.setTitle(localize("landing_cta_text").uppercased(), for: .normal)
        button.titleLabel?.font = config.ctaFont
        button.layer.cornerRadius = 3
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(45)
            $0.left.equalTo(35)
            $0.bottom.equalTo(-35)
        }
        button.addTarget(self, action: #selector(start), for: .touchUpInside)


        text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 0
        view.addSubview(text)
        text.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(35)
        }
        text.text = nil

        title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
        loadConfig()
        super.viewWillAppear(animated)
    }

    private func loadConfig() {
        backgroundImage.image = config.landingBackgroundImage

        for v in logoContainer.subviews { v.removeFromSuperview() }
        if let brand = config.landingBrandView {
            logoContainer.addSubview(brand)
            brand.snp.makeConstraints { $0.edges.equalToSuperview() }
        }

        if let landing = config.landingText {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineHeightMultiple = 1.5
            paragraph.alignment = .center
            let attributedString = NSAttributedString(
                string: landing,
                attributes: [
                    NSFontAttributeName: config.landingTextFont,
                    NSParagraphStyleAttributeName: paragraph,
                    NSForegroundColorAttributeName: config.landingTextColor,
                    NSKernAttributeName: 1.8
                ])
            text.attributedText = attributedString
        } else {
            text.text = nil
        }

        if config.isClosable == false {
            navigationItem.rightBarButtonItem = nil
        } else {
            let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stop))
            navigationItem.rightBarButtonItem = close
        }
    }

    private func setupNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }

    func start() {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }

    func stop() {
        dismiss(animated: true)
    }
}
