//
//  DeleteAccountView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/8/25.
//

import SwiftUI

struct DeleteAccountView: View {
    let networkingManager = NetworkingManager()
    @StateObject private var appState = AppState.shared
    @State private var currentPassword = ""
    @State private var errorMessage = "Incorrect Password, Please Try Again"
    @State private var successMessage = "Account Successfully deleted"
    @State private var showError = false
    @State private var showSuccess = false
    
    var body: some View {
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
    private func validateCurrentPassword () {
        var correctPassword = ""
        let userID = appState.currentUserID
        let url = "http://localhost:8080/api/users/\(userID!)"
        
        // Send a request to get users password from the server
        networkingManager.getRequest(url: url) { response in
            if let jsonResponse = response as? [String: Any] {
                correctPassword = jsonResponse["passwordHash"] as! String
                
                // If given password is the right password delete account
                if (currentPassword == correctPassword) {
                    print("Account Deleted")
                    DispatchQueue.main.async {
                        showSuccess = true
                        showError = false
                    }
                    
                    // Wait 1 second and delete account
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        networkingManager.deleteRequest(url: url) { response in
                        }
                        
                        // Logout and direct to login screen
                        DispatchQueue.main.async {
                            appState.logout()
                        }
                    }
                    
                } else {
                    errorMessage = "Incorrect password, Please try again"
                    showError = true
                }
                
            } else {
                print("Error with jsonResponse")
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}

