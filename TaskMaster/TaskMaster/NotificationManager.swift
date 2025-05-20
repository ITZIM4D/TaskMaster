import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error)")
                }
                completion(granted)
            }
        }
    }
    
    // Schedule deadline approaching notifications
    func scheduleDeadlineNotification(taskId: Int, taskTitle: String, dueDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Deadline Approaching"
        content.body = "'\(taskTitle)' is due soon. Don't forget to complete it!"
        content.sound = .default
        
        // Calculate to show the notification 24 hours before due date
        let notificationDate = Calendar.current.date(byAdding: .hour, value: -24, to: dueDate) ?? Date()
        
        // Only schedule if the notification time is in the future
        if notificationDate > Date() {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // Create a unique identifier for this deadline notification
            let identifier = "deadline-\(taskId)"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling deadline notification: \(error)")
                }
            }
        }
    }
    
    func scheduleNoProgressNotification(taskId: Int, taskTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "You haven't made progress on '\(taskTitle)' yet. You can do this!"
        content.sound = .default
        
        // Send this notification a few days after task creation
        let triggerDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = "no-progress-\(taskId)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling no progress notification: \(error)")
            }
        }
    }
    
    func sendProgressEncouragementNotification(taskTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Great Progress!"
        content.body = "You're making good progress on '\(taskTitle)'. Keep it up!"
        content.sound = .default
        
        // Trigger immediately (using a 1 second delay)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = "progress-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending progress notification: \(error)")
            }
        }
    }
    
    // Cancel notifications when they're no longer needed
    func cancelNotificationForTask(taskId: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["deadline-\(taskId)", "no-progress-\(taskId)"]
        )
    }
    
    // This is what you'll call whenever tasks are loaded or updated
    func updateNotificationsForTasks(tasks: [TaskItem]) {
        var completedSubtasksCount = 0
        var hasProgress = true
        
        // First, get existing notification IDs to avoid duplicate scheduling
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let existingIds = requests.map { $0.identifier }
            
            for task in tasks {
                // Check if task is completed
                if task.completedAt != nil {
                    // Cancel any pending notifications for completed tasks
                    self.cancelNotificationForTask(taskId: task.id)
                    continue
                }
                
                // Check if deadline is in the future
                let deadlineString = task.taskDeadline
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let deadlineDate = dateFormatter.date(from: deadlineString)
                
                if deadlineDate! > Date() {
                    // Check if we already have a deadline notification
                    let deadlineId = "deadline-\(task.id)"
                    if !existingIds.contains(deadlineId) {
                        self.scheduleDeadlineNotification(
                            taskId: task.id,
                            taskTitle: task.taskName,
                            dueDate: deadlineDate!
                        )
                    }
                }
                let networkingManager = NetworkingManager()
                let url = "http://localhost:8080/api/tasks/\(String(task.id))/subtasks/completed"
                
                networkingManager.getRequest(url: url) { jsonResponse in
                    // Here, we are assuming the response will have a "count" key with an integer value.
                    guard let response = jsonResponse as? [String: Any], let count = response["count"] as? Int else {
                        print("Invalid data format")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        // Here, we can store or display the count as needed
                        print("Completed subtasks count: \(count)")
                        // If needed, store it as an integer in a variable
                        var completedSubtasksCount = count
                    }
                }
                
                if (completedSubtasksCount == 0) {
                    let hasProgress = false
                }
                
                // Check if we should send a "no progress" notification
                if !hasProgress && !existingIds.contains("no-progress-\(task.id)") {
                    self.scheduleNoProgressNotification(taskId: task.id, taskTitle: task.taskName)
                }
                
                
            }
        }
    }
    
    func sendTestDeadlineNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Deadline Approaching"
        content.body = "Your task 'Complete Project' is due soon!"
        content.sound = .default
        
        // Show in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "test-deadline-\(Int.random(in: 1...1000))",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending test deadline notification: \(error)")
            } else {
                print("Test deadline notification scheduled!")
            }
        }
    }

    // Test notification for no progress
    func sendTestNoProgressNotification() {
        let content = UNMutableNotificationContent()
        content.title = "No Progress Yet"
        content.body = "You haven't started \"Study For Test\" yet. You can do this!"
        content.sound = .default
        
        // Show in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "test-noprogress-\(Int.random(in: 1...1000))",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending test no-progress notification: \(error)")
            } else {
                print("Test no-progress notification scheduled!")
            }
        }
    }

    // Test notification for progress made
    func sendTestProgressNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Great Progress!"
        content.body = "You're making good progress on 'Research Paper'. Keep it up!"
        content.sound = .default
        
        // Show in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "test-progress-\(Int.random(in: 1...1000))",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending test progress notification: \(error)")
            } else {
                print("Test progress notification scheduled!")
            }
        }
    }
}
