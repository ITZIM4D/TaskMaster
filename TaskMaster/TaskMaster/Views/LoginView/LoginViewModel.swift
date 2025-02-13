//
//  LoginViewModel.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/14/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var passwordHash: String = ""
    
    func login() {
        let loginRequest = LoginRequest(
            username: username,
            passwordHash: passwordHash
        )
        
        LoginAction().call(parameters: loginRequest) { success in
            DispatchQueue.main.async {
                if success {
                    // Use AppState to set login state
                    AppState.shared.login(username: self.username)
                    print("Sucess")
                } else {
                    print("Login failed")
                }
            }
        }
    }
}
