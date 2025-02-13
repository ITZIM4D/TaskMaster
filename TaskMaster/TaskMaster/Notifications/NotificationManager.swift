//
//  NotificationManager.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/14/25.
//

import UserNotifications
import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleTaskNotification(for task: TasksView.TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to complete: \(task.taskName)"
        content.sound = .default
        
        // Convert task deadline string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let deadlineDate = dateFormatter.date(from: task.taskDeadline) else {
            print("Invalid date format")
            return
        }
        
        // Schedule notification 1 hour before deadline
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: deadlineDate)
        guard let triggerDate = triggerDate else { return }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "task-\(task.taskID)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for taskID: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["task-\(taskID)"])
    }
    
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
