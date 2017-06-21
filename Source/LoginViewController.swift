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
public class LoginViewController: UIViewController {
    let config: LoginConfiguration

    public var signedIn: ((User) -> Void)?
    public var signedUp: ((User) -> Void)?

    init(config: LoginConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.config = LoginConfiguration.default
        super.init(coder: aDecoder)
    }

    public override func loadView() {
        super.loadView()
        setupNavigation()

        let backgroundImage = UIImageView(image: config.landingBackgroundImage)
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { $0.edges.equalToSuperview() }

        if let logo = config.landingBrandView {
            view.addSubview(logo)
            logo.snp.makeConstraints {
                $0.top.equalTo(80)
                $0.left.greaterThanOrEqualTo(35)
                $0.centerX.equalToSuperview()
            }
        }

        let button = UIButton(type: .custom)
        button.backgroundColor = config.ctaBackgroundColor
        button.setTitle(NSLocalizedString("LandingCTAText", comment: "Commencer").uppercased(), for: .normal)
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


        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 0
        view.addSubview(text)
        text.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-30)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(35)
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.5
        paragraph.alignment = .center
        let attributedString = NSAttributedString(
            string: NSLocalizedString("LandingText", comment: "Lorem Ipsum"),
            attributes: [
                NSFontAttributeName: config.landingTextFont,
                NSParagraphStyleAttributeName: paragraph,
                NSForegroundColorAttributeName: config.landingTextColor,
                NSKernAttributeName: 1.8
            ])
        text.attributedText = attributedString

        title = ""
    }

    private func setupNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white

        let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stop))
        navigationItem.rightBarButtonItem = close
    }

    func start() {
        let controller = SignInViewController(config: config)
        controller.signedIn = signedIn
        controller.signedUp = signedUp
        navigationController?.pushViewController(controller, animated: true)
    }

    func stop() {
        dismiss(animated: true)
    }
}
