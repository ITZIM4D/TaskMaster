//
//  ProgressView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 9/5/24.
//

import SwiftUI

struct ProgressView: View {
    let networkingManager = NetworkingManager()
    @StateObject private var appState = AppState.shared
    @State private var userID = 0
    @State private var completedTasks = 0
    @State private var totalTasks = 0
    @State private var pendingTasks = 0
    
    var body: some View {
        VStack {
            ProgressHeader()
            ProgressGraphView()
            Spacer()
        }
        
    }
        
        

    }

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
