//
//  TabBar.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/3/24.
//

import SwiftUI

enum Tabs: Int {
    case tasks = 0
    case feedback = 1
    case progress = 2
    case settings = 3
}

struct TabBar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        ZStack{
            Color(red: 204 / 255, green: 229 / 255, blue: 255 / 255)
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: 82)
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: geometry.size.width / 15) { // Adjust spacing based on screen width
                        // Button to switch to Tasks
                        Button {
                            // Set the selected tab to tasks
                            selectedTab = .tasks
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image("clipboard")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("Tasks")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .tasks){
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 3)
                                }
                            }
                        }
                        
                        // Button to switch to feedback
                        Button {
                            // Set the selected tab to feedback
                            selectedTab = .feedback
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.black)
                                Text("Feedback")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .feedback){
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 3)
                                }
                            }
                        }
                        
                        // Button to switch to Progress
                        Button {
                            // Set the selected tab to progress
                            selectedTab = .progress
                            
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image("bar-chart")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("Progress")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .progress){
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 3)
                                }
                            }
                        }
                        
                        // Button to switch to Settings
                        Button {
                            // Set the selected tab to settings
                            selectedTab = .settings
                            
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image("settings")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("Settings")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .settings){
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 3)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width, height: 82)
                }
                .frame(height: 82) // Fixed height for the TabBar
            }
        }
    }
}

struct TabBar_Preview: PreviewProvider {
    @State static var selectedTab: Tabs = .tasks

    static var previews: some View {
        TabBar(selectedTab: $selectedTab)
    }
}
