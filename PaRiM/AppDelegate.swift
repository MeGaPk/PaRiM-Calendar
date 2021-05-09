//
//  AppDelegate.swift
//  PaRiM
//
//  Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = MainViewController()
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible()
        return true
    }

}

