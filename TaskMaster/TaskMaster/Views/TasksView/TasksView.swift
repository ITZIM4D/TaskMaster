//
//  TasksView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/5/24.
//

import SwiftUI

/*
 - The task view takes whatever tasks that you have in that calendar day and puts them in
 order by when they are scheduled to be done by
 
 - Has a button to create a task
 */

struct TasksView: View {
    var body: some View {
        VStack{
            
            TasksHeader()
                .padding(.top, 40)
    
            // Button to make new tasks. Maybe sends you to task creation view?
            Button{
                createTask()
            } label: {Text("Create Tasks")}
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}



/* 
 Function to create a task.
 
 I don't know whether I want it to return a new object of task item or just create it in the function
 most likely just create it in the method
 */
func createTask(){
    print("success")
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
