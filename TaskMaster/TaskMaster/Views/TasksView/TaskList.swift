//
//  TaskList.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/8/24.
//

import SwiftUI

// Define the Task model
struct Task: Identifiable {
    let id = UUID()
    var name: String
}

// Define the TaskManager to manage tasks
class TaskManager: ObservableObject {
    @Published var tasksM: [Task] = []

    func addTask(name: String) {
        let newTask = Task(name: name)
        tasksM.append(newTask)
    }
}

struct TaskList: View {
    @ObservedObject var taskManager: TaskManager

    var body: some View {
        VStack {
            List(taskManager.tasksM) { task in
                Text(task.name)
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList(taskManager: TaskManager())
    }
}
