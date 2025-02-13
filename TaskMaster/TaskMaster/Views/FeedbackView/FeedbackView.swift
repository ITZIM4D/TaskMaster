//
//  FeedbackView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/15/25.
//

import SwiftUI

struct FeedbackView: View {
    @State private var tasks: [TaskItem] = []
    @StateObject private var appState = AppState.shared
    let networkingManager = NetworkingManager()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                FeedbackHeader()
                    .padding(.top, geometry.size.height / 14)
                
                // Scrollable task list in a box
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(tasks) { task in
                            NavigationLink(destination: GetFeedbackView(task: task)) {
                                HStack {
                                    Text(task.taskName)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
                .frame(height: geometry.size.height / 4)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                .onAppear {
                    loadTasks()
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func loadTasks() {
        let url = "http://localhost:8080/api/tasks"
        
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
                    
                    if (username == appState.currentUsername && taskStatus == "Completed") {
                        return TaskItem(
                            taskID: taskID,
                            taskName: taskName,
                            taskDeadline: taskDeadline,
                            taskStatus: taskStatus,
                            createdAt: createdAt,
                            completedAt: completedAt
                        )
                    } else {
                        return nil
                    }
                    
                }
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
