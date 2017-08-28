//
//  AppDelegate.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-26.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }

}

