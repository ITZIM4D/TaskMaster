//
//  ContentView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 8/17/24.
//

import SwiftUI

// Main view
struct ContentView: View {
    
    @State var selectedTab: Tabs = .tasks
    
    var body: some View {
        VStack {
            // Make a switch statement for tabs
            switch selectedTab {
                case .tasks:
                    TasksView()
                case .stressCheck:
                    StressCheckView()
                case .progress:
                    ProgressView()
                case .profile:
                    ProfileView()
                        }
            Spacer()
            Spacer()
            TabBar(selectedTab: $selectedTab)
                .offset(y: 25)
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
