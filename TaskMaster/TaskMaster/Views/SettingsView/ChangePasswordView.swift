//
//  ChangePasswordView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/8/25.
//

import SwiftUI

struct ChangePasswordView: View {
    let networkingManager = NetworkingManager()
    @StateObject private var appState = AppState.shared
    @State private var currentStep = 1
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @State private var successMessage = "Successfully Changed Password!"
    
    var body: some View {
        VStack (spacing: 20) {
            // First step, have to confirm password to change password
            if currentStep == 1 {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Confirm Current Password")
                        .font(.headline)
                        .padding(.top)
                        .padding(.leading)
                    
                    SecureField("Current Password", text: $currentPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: validateCurrentPassword) {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            } else {
                // Step 2: Enter new password
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter New Password")
                        .font(.headline)
                        .padding(.top)
                        .padding(.leading)
                    
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Confirm New Password", text: $confirmNewPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: changePassword) {
                        Text("Change Password")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            if showSuccess {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Spacer()
        }
    }
    
    private func validateCurrentPassword () {
        var correctPassword = ""
        let userID = appState.currentUserID
        let url = "http://localhost:8080/api/users/\(userID!)"
        
        // Send a request to get users password from the server
        networkingManager.getRequest(url: url) { response in
            if let jsonResponse = response as? [String: Any] {
                correctPassword = jsonResponse["passwordHash"] as! String
                
                // If given password is the right password move to step 2
                if (currentPassword == correctPassword) {
                    showError = false
                    currentStep = 2
                } else {
                    errorMessage = "Incorrect password, Please try again"
                    showError = true
                }
                
            } else {
                print("Error with jsonResponse")
            }
        }
    }
    
    private func changePassword() {
        // Check if the new and old password are the same
        if newPassword == currentPassword {
            errorMessage = "New password cannot be the same as the current password"
            showError = true
            return
        }
        
        // If both passwords match change password with post request
        if newPassword == confirmNewPassword {
            let userID = appState.currentUserID
            let url = "http://localhost:8080/api/users/\(userID!)/password"
            showSuccess = true
            
            let jsonPayload: [String: Any] = [
                "passwordHash": newPassword
            ]
            
            networkingManager.postRequest(url: url, json: jsonPayload) { response in
                
            }
            showError = false
        } else {
            errorMessage = "Passwords do not match, please try again"
            showError = true
        }
    }
    
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
