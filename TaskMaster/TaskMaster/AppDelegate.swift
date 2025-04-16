//
//  AppDelegate.swift
//  TaskMaster
//
//  Created by Jared Wilson on 4/12/25.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Request notification permissions
        requestNotificationPermission()
        return true
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
