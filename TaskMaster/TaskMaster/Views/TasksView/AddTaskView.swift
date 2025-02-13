import SwiftUI



struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var appState = AppState.shared
    let networkingManager = NetworkingManager()
    
    @State private var taskName = ""
    @State private var taskDeadline = Date()
    @State private var taskStatus: String = "In Progress"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $taskName)
                    
                    DatePicker("Deadline", selection: $taskDeadline, displayedComponents: .date)
                    
                }
                
                Section {
                    Button("Save Task") {
                        subtaskify()
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func subtaskify() {
        // Format JSON Body
        let taskData: [String: Any] = [
            "taskDescription": taskName
        ];
        
        // Set the breakdown url
        let url = "http://localhost:8080/api/taskBreakdown/generate"
        
        // Send the post request and get the response
        networkingManager.postRequest(url: url, json: taskData) { response in
            if let subtasks = response as? [String] {
                saveTask { taskID in
                    for subtask in subtasks {
                        let subtaskData: [String: Any] = [
                            "subtaskName": subtask,
                            "taskStatus": "In Progress",
                            "task": [
                                "taskID": taskID
                            ]
                        ]
                        
                        let subtaskURL = "http://localhost:8080/api/subtasks"
                        
                        networkingManager.postRequest(url: subtaskURL, json: subtaskData) { response in
                            
                        }
                    }
                }
            } else {
                print("Failed to cast subtasks to string")
            }
        }
    }
    
    private func saveTask(completion: @escaping (Int) -> Void) {
        // Ensure a task name is provided
        guard !taskName.isEmpty else {
            return
        }
        
        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format JSON body
        let taskData: [String: Any] = [
            "taskName": taskName,
            "taskDeadline": dateFormatter.string(from: taskDeadline),
            "taskStatus": taskStatus,
            "user": ["userID": appState.currentUserID!],
        ]
        
        // Send POST request to add task
        networkingManager.postRequest(url: "http://localhost:8080/api/tasks", json: taskData) { response in
            if let taskResponse = response as? [String: Any],
               let taskID = taskResponse["taskID"] as? Int {
                completion(taskID)
                
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
