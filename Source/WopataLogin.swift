//
//  Login.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import GoogleSignIn

public class WopataLoginConfiguration {
    public var landingBackgroundImage: UIImage? = nil
    public var landingBrandView: UIView? = nil

    public var landingTextFont: UIFont = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
    public var landingTextColor: UIColor = .white

    public var ctaBackgroundColor: UIColor = UIColor(red: 73.0/255, green: 144.0/255, blue: 226.0/255, alpha: 1)
    public var ctaFont: UIFont = .systemFont(ofSize: 15, weight: UIFontWeightHeavy)
    public var ctaTextColor: UIColor = .white

    public var font: UIFont = .systemFont(ofSize: 14)

    public static let `default`: WopataLoginConfiguration = {
        let config = WopataLoginConfiguration()
        // set default
        return config
    }()
}

public class User {
    public enum UserSource {
        case facebook, google, native
    }

    public var token: String?
    public var email: String?
    public var password: String?
    public var source: UserSource

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
        guard let top = (mainController as? UINavigationController)?.visibleViewController as? ErrorHandler else { return }
        top.addError(field: field, message: message)
    }

    public lazy var mainController: UIViewController = {
        let navigation = UINavigationController(rootViewController: LoginViewController())
        return navigation
    }()

    public func configure(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let data = NSDictionary(contentsOfFile: path),
            let clientID = data["CLIENT_ID"] as? String {
            GIDSignIn.sharedInstance().clientID = clientID
        }

//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError!)")
    }

    public func handle(url: URL, application: UIApplication, sourceApplication: String?, annotation: Any?) -> Bool {
        if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }

        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }

        return true
    }
}

protocol ErrorHandler {
    func addError(field: WopataLoginField, message: String)
}
