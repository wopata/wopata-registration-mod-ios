//
//  Login.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

public class WopataLoginConfiguration {
    var landingBackgroundImage: UIImage? = nil
    var landingBrandView: UIView? = nil

    var landingTextFont: UIFont = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
    var landingTextColor: UIColor = .white

    var ctaBackgroundColor: UIColor = UIColor(red: 73.0/255, green: 144.0/255, blue: 226.0/255, alpha: 1)
    var ctaFont: UIFont = .systemFont(ofSize: 15, weight: UIFontWeightHeavy)
    var ctaTextColor: UIColor = .white

    var font: UIFont = .systemFont(ofSize: 14)

    static let `default`: WopataLoginConfiguration = {
        let config = WopataLoginConfiguration()
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

public enum WopataLoginField { case email, password, facebook, google }
public class WopataLogin {
    public var config = WopataLoginConfiguration.default
    public var signedIn: ((User) -> Void)?
    public var signedUp: ((User) -> Void)?

    public static var shared: WopataLogin = {
        return WopataLogin()
    }()

    public func addError(field: WopataLoginField, message: String) {
        guard let top = mainController.navigationController?.visibleViewController as? ErrorHandler else { return }
        top.addError(field: field, message: message)
    }

    public lazy var mainController: UIViewController = {
        let navigation = UINavigationController(rootViewController: LoginViewController())
        return navigation
    }()
}

protocol ErrorHandler {
    func addError(field: WopataLoginField, message: String)
}
