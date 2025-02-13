//
//  AddTaskButton.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/8/24.
//

import SwiftUI

struct AddTaskButton: View {
    @State private var showingAddTaskView = false
    @Binding var refreshTrigger: Bool
    var onRefresh: () -> Void
    
    var body: some View {
        HStack {
            Text("Add Task")
                .font(.system(size: 30))
                .frame(width: 125, alignment: .center)
            
            Button(action: {
                showingAddTaskView = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.leading, 5)
            .sheet(isPresented: $showingAddTaskView, onDismiss: {
                refreshTrigger.toggle()
                onRefresh()
            }) {
                AddTaskView()
            }
        }
    }
}

struct AddTaskButton_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskButton(refreshTrigger: .constant(false), onRefresh: {})
    }
}


