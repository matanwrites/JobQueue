//
//  AppDelegate.swift
//  JobQueueExample
//
//  Created by sintaiyuan on 9/7/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import UIKit
import JobQueue

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        JobQueueCenter.current.executeNext()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        JobQueueCenter.current.tryPersist()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        JobQueueCenter.current.tryPersist()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        JobQueueCenter.current.tryPersist()
    }
    
    func intermitentSaveForDebug() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            JobQueueCenter.current.persist()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        for easier debug
        JobQueueCenter.current.executeNext()
    }
}


