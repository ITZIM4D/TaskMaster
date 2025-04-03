// The model for any task item
import Foundation

struct TaskItem: Identifiable {
    var id: Int { taskID }
    var taskID: Int
    var taskName: String
    var taskDeadline: String
    var taskStatus: String
    var createdAt: String
    var completedAt: String?
}
