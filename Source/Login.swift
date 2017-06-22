//
//  Login.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

public class LoginConfiguration {
    var landingBackgroundImage: UIImage? = nil
    var landingBrandView: UIView? = nil

    var landingTextFont: UIFont = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
    var landingTextColor: UIColor = .white

    var ctaBackgroundColor: UIColor = UIColor(red: 73.0/255, green: 144.0/255, blue: 226.0/255, alpha: 1)
    var ctaFont: UIFont = .systemFont(ofSize: 15, weight: UIFontWeightHeavy)
    var ctaTextColor: UIColor = .white

    var font: UIFont = .systemFont(ofSize: 14)

    static let `default`: LoginConfiguration = {
        let config = LoginConfiguration()
        // set default
        return config
    }()
}

public class User {
    enum UserSource {
        case facebook, google, native
    }

    var token: String?
    var email: String?
    var password: String?
    var source: UserSource

    init(source: UserSource, token: String? = nil, email: String? = nil, password: String? = nil) {
        self.source = source
        self.token = token
        self.email = email
        self.password = password
    }
}

public enum LoginField { case email, password, facebook, google }
public class Login {
    public var config = LoginConfiguration.default
    public var signedIn: ((User) -> Void)?
    public var signedUp: ((User) -> Void)?

    public static var shared: Login = {
        return Login()
    }()

    public func addError(field: LoginField, message: String) {
        guard let top = mainController.navigationController?.visibleViewController as? ErrorHandler else { return }
        top.addError(field: field, message: message)
    }

    public lazy var mainController: UIViewController = LoginViewController()
}

protocol ErrorHandler {
    func addError(field: LoginField, message: String)
}
