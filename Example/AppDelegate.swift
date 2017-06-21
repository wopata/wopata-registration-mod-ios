//
//  AppDelegate.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError!)")

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let srcApp = options[.sourceApplication] as? String
        let annotation = options[.annotation]
        if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: srcApp, annotation: annotation) {
            return true
        }

        if GIDSignIn.sharedInstance().handle(url, sourceApplication: srcApp, annotation: annotation) {
            return true
        }

        return true
    }

}

