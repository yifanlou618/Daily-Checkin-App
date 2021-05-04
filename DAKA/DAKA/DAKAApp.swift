//
//  DAKAApp.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import UserNotifications

@main
struct DAKAApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let coredata_manager = CoreDataManager.shared
    var body: some Scene {
        
        WindowGroup {
//            VStack {
//                Button("Request Permission") {
//                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                        if success {
//                            print("All set!")
//                        } else if let error = error {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                Button("Schedule Notification") {
//                    let content = UNMutableNotificationContent()
//                    content.title = "Feed the cat"
//                    content.subtitle = "It looks hungry"
//                    content.sound = UNNotificationSound.default
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                    UNUserNotificationCenter.current().add(request)
//                }
//            }
            ContentView()
                .environment(\.managedObjectContext, coredata_manager.container.viewContext)
        }
    }
}

