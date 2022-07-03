//
//  LocalNotificationManager.swift
//  Time To Go
//
//  Created by Joshua McKinnon on 3/7/2022.
//

import Foundation
import SwiftUI

class LocalNotificationManager: ObservableObject {
    
    var notifications = [Notification]()

    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("Notifications Allowed")
            } else {
                print("Notifications Not Allowed")
            }
        }
    }
    
    func triggerReminder() {
        self.sendNotification(title: "Time to Leave", subtitle: "Keep on Track", body: "You asked to be reminded to leave after one hour", launchAfter: 60)
        print("Reminder Triggered")
    }
    
    private func sendNotification(title: String, subtitle: String?, body: String, launchAfter: Double) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.sound = UNNotificationSound.default
        content.interruptionLevel = .timeSensitive
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchAfter, repeats: true)
        let request = UNNotificationRequest(identifier: "Get Out Notifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//
//        let leaveContent = UNMutableNotificationContent()
//        leaveContent.title = "Well Done"
//        leaveContent.subtitle = "You're Getting On With It"
//        content.body = "You've left the location and we won't nag you anymore"
//        content.sound = UNNotificationSound.default
//        content.interruptionLevel = .active
//
//        let leaveTrigger = UNLocationNotificationTrigger(region: <#T##CLRegion#>, repeats: <#T##Bool#>)
    }
    
    
    func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
//    func timeUntilReminder() -> TimeInterval? {
//        let nextTriggerDate: Date
//        UNUserNotificationCenter.current().getPendingNotificationRequests() {(requests) in
//            for request in requests {
//                if let trigger = (request.trigger)? as UNTimeIntervalNotificationTrigger {
//                    if let nextTriggerDate = trigger.nextTriggerDate() {
//                        return trigger.nextTriggerDate().timeIntervalSinceNow
//                    } else {
//                        if trigger.nextTriggerDate() < nextTriggerDate {
//                            nextTriggerDate = trigger.nextTriggerDate()
//                            return nextTriggerDate.timeIntervalSinceNow
//                        }
//                    }
//                }
//            }
//            return nil
//        }
//    }
}
