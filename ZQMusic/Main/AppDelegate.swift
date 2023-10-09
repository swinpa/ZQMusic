//
//  AppDelegate.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var __window:UIWindow?
    
    var window: UIWindow? {
        get {
            __window
        }
        set {
            __window = newValue
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ZQMTabBarController.tabBarController()
        self.window?.makeKeyAndVisible()
        
        
        return true
    }
}

