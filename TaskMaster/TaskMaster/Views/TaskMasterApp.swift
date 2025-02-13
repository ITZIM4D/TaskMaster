//
//  TaskMasterApp.swift
//  TaskMaster
//
//  Created by Jared Wilson on 8/17/24.
//

import SwiftUI

@main
struct TaskMasterApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(loginViewModel)
        }
    }
}
