//
//  TabBar.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/3/24.
//

import SwiftUI

enum Tabs: Int {
    case tasks = 0
    case stressCheck = 1
    case progress = 2
    case profile = 3
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
                        
                        // Button to switch to StressCheck
                        Button {
                            // Set the selected tab to Stress check
                            selectedTab = .stressCheck
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image("stress-relief")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("Stress Check")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .stressCheck){
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
                        
                        // Button to switch to Profile
                        Button {
                            // Set the selected tab to profile
                            selectedTab = .profile
                            
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image("user")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Text("Profile")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                
                                if (selectedTab == .profile){
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
