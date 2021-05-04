//
//  AppDelegate.swift
//  DAKA
//
//  Created by Zhiyue Gao on 5/1/21.
//

import Foundation
import SwiftUI
import UserNotifications
import os

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
             //This callback does not trigger on main loop be careful
            if allowed {
              os_log(.debug, "Allowed") //import os
            } else {
              os_log(.debug, "Error")
            }
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let defaults = UserDefaults.standard
        let lastDate:String = defaults.object(forKey: "Date") as? String ?? ""
        let todayDate:String = getDate()
        // if when returning to active, it comes a new day: we refresh the "today" goal list
        if lastDate != todayDate {
            // you just refill today's list with goals list's contents
        }
    }
    
    // Datetime transform function
    public func getDate() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
}
