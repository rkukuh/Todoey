//
//  AppDelegate.swift
//  Todoey
//
//  Created by R. Kukuh on 03/01/18.
//  Copyright © 2018 R. Kukuh. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("CALLED: didFinishLaunchingWithOptions()")
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        print("CALLED: applicationWillTerminate()")
    }

}

