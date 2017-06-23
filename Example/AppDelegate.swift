//
//  AppDelegate.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import WopataLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        WopataLogin.shared.configure(application: application, launchOptions: launchOptions)
        Fabric.with([Crashlytics.self])

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let srcApp = options[.sourceApplication] as? String
        let annotation = options[.annotation]
        return WopataLogin.shared.handle(url: url, application: app, sourceApplication: srcApp, annotation: annotation)
    }

}

