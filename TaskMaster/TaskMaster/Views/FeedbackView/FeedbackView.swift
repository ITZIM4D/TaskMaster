// Tab that allows the user to select finished tasks to make feedback on
// And allows users to receive feeback

import SwiftUI

struct FeedbackView: View {
    @State private var tasks: [TaskItem] = []
    @State private var taskFeedback: [Int: (feedback: TaskFeedback, recommendation: String)] = [:]
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
                
                // Scrollable task feedback list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(tasks) { task in
                            if let feedbackInfo = taskFeedback[task.taskID] {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(task.taskName)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    Text(feedbackInfo.recommendation)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
                
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear() {
            loadTasks()
        }
    }
    
    // Loads tasks in from API
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
                    
                    if (username == appState.currentUsername && taskStatus == "Completed") {
                        let task = TaskItem(
                            taskID: taskID,
                            taskName: taskName,
                            taskDeadline: taskDeadline,
                            taskStatus: taskStatus,
                            createdAt: createdAt,
                            completedAt: completedAt
                        )
                        loadFeedback(for: task)
                        return task
                    } else {
                        return nil
                    }
                    
                }
                self.tasks.sort { task1, task2 in
                    return task1.taskID > task2.taskID  // Higher ID first
                }
            }
        }
    }
    
    func loadFeedback(for task: TaskItem) {
        let url = "http://localhost:8080/api/feedback/task/\(task.taskID)"
        
        networkingManager.getRequest(url: url) { jsonResponse in
            guard let feedbacks = jsonResponse as? [[String: Any]] else {
                print("Invalid feedback data format")
                return
            }
            
            let sortedFeedbacks = feedbacks.sorted { feedback1, feedback2 in
                guard let date1 = feedback1["createdAt"] as? String,
                      let date2 = feedback2["createdAt"] as? String else {
                    return false
                }
                return date1 > date2
            }
            
            
            
            if let mostRecentFeedback = sortedFeedbacks.first {
                DispatchQueue.main.async {
                    let feedback = TaskFeedback (
                        difficulty: mostRecentFeedback["difficulty"] as? Int ?? 0,
                        timeAccuracy: mostRecentFeedback["timeAccuracy"] as? String ?? "Unknown",
                        challenges: mostRecentFeedback["challenges"] as? String ?? "",
                        createdAt: mostRecentFeedback["createdAt"] as? String ?? ""
                    )
                    let recommendation = mostRecentFeedback["reccomendation"] as? String ?? "No recommendation available"
                    self.taskFeedback[task.taskID] = (feedback, recommendation)
                }
            }
        }
    }
}




struct TaskFeedback {
    let difficulty: Int
    let timeAccuracy: String
    let challenges: String
    let createdAt: String
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}

