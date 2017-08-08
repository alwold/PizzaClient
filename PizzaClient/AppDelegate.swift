//
//  AppDelegate.swift
//  PizzaClient
//
//  Created by Al Wold on 8/3/17.
//  Copyright © 2017 Al Wold. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UINavigationBar.appearance().barTintColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .red
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = UIColor(white: 0.9, alpha: 1.0)
    }

}

