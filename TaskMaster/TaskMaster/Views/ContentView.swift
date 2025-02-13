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
            case .feedback:
                FeedbackView()
            case .progress:
                ProgressView()
            case .settings:
                SettingsView()
            }
            Spacer()
            Spacer()
            TabBar(selectedTab: $selectedTab)
                .offset(y: 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
