//
//  GetFeedbackView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/18/25.
//

import SwiftUI

struct GetFeedbackView: View {
    var task: TaskItem
    @State private var difficulty: Int = 1
    @State private var timeAccuracy: String = "Expected"
    @State private var challenges: String = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var appState = AppState.shared
    let networkingManager = NetworkingManager()
    
    // Options to choose from for time taken
    private let timeOptions = ["Less", "Expected", "More"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Task Feedback")) {
                    Text("Task: \(task.taskName)")
                        .font(.headline)
                        .padding(.vertical, 4)
                }
                
                Section(header: Text("How difficult was this task?")) {
                    HStack (spacing: 15){
                        ForEach(1...5, id: \.self) { rating in
                            Button(action: {
                                difficulty = rating
                            }) {
                                Image(systemName: rating <= difficulty ? "star.fill" : "star")
                                    .foregroundColor(rating <= difficulty ? .yellow : .gray)
                                    .scaleEffect(1.5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                }
                
                Section(header: Text("How long did it take compared to your estimate?")) {
                    Picker("Time Accuracy", selection: $timeAccuracy) {
                        ForEach(timeOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("What challenges did you face?")) {
                    TextEditor(text: $challenges)
                        .frame(height: 100)
                }
                
                Button(action: submitFeedback) {
                    Text("Submit Feedback")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    private func submitFeedback() {
        let userID = appState.currentUserID!
        
        let jsonPayload: [String: Any] = [
            "userID": userID,
            "taskID": task.taskID,
            "difficulty": difficulty,
            "timeAccuracy": timeAccuracy,
            "challenges": challenges
        ]
        
        let url = "http://localhost:8080/api/feedback"
        
        networkingManager.postRequest(url: url, json: jsonPayload) { response in
            print(response!)
        }
        
    }
}

struct GetFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = TaskItem(
            taskID: 4,
            taskName: "Organize Team Outing",
            taskDeadline: "2024-11-15",
            taskStatus: "Completed",
            createdAt: "2024-11-01T08:19:26",
            completedAt: nil
        )
        
        GetFeedbackView(task: sampleTask)
    }
}
