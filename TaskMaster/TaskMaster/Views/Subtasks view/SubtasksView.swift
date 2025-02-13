import SwiftUI

struct SubtasksView: View {
    let task: TaskItem
    @State private var subtasks: [SubtaskItem] = []
    let networkingManager = NetworkingManager()
    
    var body: some View {
        VStack {
            Text(task.taskName)
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(subtasks) { subtask in
                        HStack {
                            Button(action: {
                                toggleSubtaskCompletion(subtask: subtask)
                            }) {
                                Image(systemName: subtask.completedAt != nil ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(subtask.completedAt != nil ? .green : .gray)
                                    .font(.system(size: 24))
                            }
                            .padding(.leading, 8)
                            
                            Text(subtask.subtaskName)
                                .font(.system(size: 20))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .onAppear {
                loadSubtasks()
            }
        }
    }
    
    private func toggleSubtaskCompletion(subtask: SubtaskItem) {
        let url = "http://localhost:8080/api/subtasks/\(subtask.subtaskID)/toggle"
        
        // Get current date in ISO8601 format
        let dateFormatter = ISO8601DateFormatter()
        let currentDate = dateFormatter.string(from: Date())
        
        let jsonBody: [String: Any] = [
            "completedAt": subtask.completedAt == nil ? currentDate : NSNull()
        ]
        
        networkingManager.putRequest(url: url, json: jsonBody) { response in
            if response != nil {
                // Refresh the tasks list to show updated state
                loadSubtasks()
            }
        }
    }

    private func loadSubtasks() {
        let url = "http://localhost:8080/api/tasks/\(task.taskID)"
        
        networkingManager.getRequest(url: url) { jsonResponse in
            guard let response = jsonResponse as? [String: Any] else {
                print ("Invalid task data format")
                return
            }
        
            DispatchQueue.main.async {
                if let subtasksList = response["subtasks"] as? [[String: Any]] {
                    self.subtasks = subtasksList.compactMap { dict in
                        guard
                            let subtaskID = dict["subtaskID"] as? Int,
                            let subtaskName = dict["subtaskName"] as? String,
                            let subtaskStatus = dict["taskStatus"] as? String
                        else {
                            return nil
                        }
                        
                        let completedAt = dict["completedAt"] as? String
                        
                        return SubtaskItem (
                            subtaskID: subtaskID,
                            subtaskName: subtaskName,
                            subtaskStatus: subtaskStatus,
                            completedAt: completedAt
                        )
                    }
                    self.subtasks.sort { (subtask1, subtask2) -> Bool in
                        let num1 = extractSubtaskNumber(from: subtask1.subtaskName)
                        let num2 = extractSubtaskNumber(from: subtask2.subtaskName)
                        return num1 < num2
                    }
                }
            }
        }
    }
    
    private func extractSubtaskNumber(from subtaskName: String) -> Int {
        let components = subtaskName.split(separator: ".")
        if let number = components.first, let intValue = Int(number.trimmingCharacters(in: .whitespaces)) {
            return intValue
        }
        return 0
    }
}

struct SubtaskItem: Identifiable {
    var id: Int { subtaskID }
    var subtaskID: Int
    var subtaskName: String
    var subtaskStatus: String
    var completedAt: String?
}


struct SubtaskView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTask = TaskItem(
            taskID: 4,
            taskName: "Organize Team Outing",
            taskDeadline: "2024-11-15",
            taskStatus: "Completed",
            createdAt: "2024-11-01T08:19:26",
            completedAt: nil
        )
        
        SubtasksView(task: sampleTask)
    }
}
