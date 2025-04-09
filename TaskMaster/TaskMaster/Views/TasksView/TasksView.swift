//
//  TasksView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/5/24.
//


/*
 - The task view takes whatever tasks that you have in that calendar day and puts them in
 order by when they are scheduled to be done by
 
 - Has a button to create a task
 */

import SwiftUI

struct TasksView: View {
    @State private var tasks: [TaskItem] = []
    @StateObject private var appState = AppState.shared
    @State private var refreshTrigger = false
    let networkingManager = NetworkingManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                TasksHeader()
                    .padding(.top, 50)
                AddTaskButton(refreshTrigger: $refreshTrigger, onRefresh: loadTasks)
                
                ScrollView {
                    LazyVStack {
                        ForEach(tasks) { task in
                            HStack {
                                Button(action: {
                                    toggleTaskCompletion(task: task)
                                }) {
                                    Image(systemName: task.completedAt != nil ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.completedAt != nil ? .green : .gray)
                                        .font(.system(size: 24))
                                }
                                .padding(.leading, 8)
                                NavigationLink(destination: SubtasksView(task: task)) {
                                    HStack {
                                        Text(task.taskName)
                                            .font(.system(size: 30, weight: .semibold))
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 8)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 30))
                                            .padding(.trailing, 8)
                                    }
                                    .padding(.vertical, 10)
                                    
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                        if appState.currentUserID != nil {
                            timer.invalidate()
                            loadTasks()
                        }
                    }
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    func toggleTaskCompletion (task: TaskItem) {
        let url = "http://localhost:8080/api/tasks/\(task.taskID)/toggle"
        
        // Get current date in ISO8601 format
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
        let currentDate = dateFormatter.string(from: Date())
        
        let jsonBody: [String: Any] = [
            "completedAt": task.completedAt == nil ? currentDate : NSNull()
        ]
        
        networkingManager.putRequest(url: url, json: jsonBody) { response in
            if response != nil {
                // Refresh the tasks list to show updated state
                loadTasks()
            }
        }
        
    }
    
    func loadTasks() {
        let userID = appState.currentUserID!
        let url = "http://localhost:8080/api/tasks/user/\(String(userID))"
        
        networkingManager.getRequest(url: url) { jsonResponse in
            guard let response = jsonResponse as? [[String: Any]] else {
                print("Invalid data format")
                return
            }
            
            DispatchQueue.main.async {
                self.tasks = response.compactMap { dict in
                    let userDict = dict["user"] as! [String: Any]
                    let username = userDict["username"] as! String
                    let taskID = dict["taskID"] as! Int
                    let taskName = dict["taskName"] as! String
                    let taskDeadline = dict["taskDeadline"] as! String
                    let taskStatus = dict["taskStatus"] as! String
                    let createdAt = dict["createdAt"] as! String
                    let completedAt = dict["completedAt"] as? String
                    
                    if (username == appState.currentUsername) {
                        return TaskItem(
                            taskID: taskID,
                            taskName: taskName,
                            taskDeadline: taskDeadline,
                            taskStatus: taskStatus,
                            createdAt: createdAt,
                            completedAt: completedAt
                        )
                    } else {
                        return nil;
                    }
                }
                
                self.tasks.sort { task1, task2 in
                    return task1.taskID > task2.taskID  // Higher ID first
                }
            }
        }
    }
    
}



struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        let previewAppState = AppState.shared
        previewAppState.currentUsername = "user2735"
        
        return TasksView()
            .environmentObject(previewAppState)
    }
}
