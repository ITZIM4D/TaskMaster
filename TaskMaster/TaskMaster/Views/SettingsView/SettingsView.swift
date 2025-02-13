//
//  SettingsView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/7/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var navigateToLogin = false
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                SettingsHeader()
                    .padding(.top, 50)
                
                VStack(spacing: 10) {
                    // Change Password
                    NavigationLink(destination: ChangePasswordView()) {
                        SettingsButton(title: "Change Password", iconName: "lock.rotation")
                    }
                    
                    // Delete Account
                    NavigationLink(destination: DeleteAccountView()) {
                        SettingsButton(title: "Delete Account", iconName: "person.crop.circle.badge.minus")
                            .foregroundColor(.red)
                    }
                    
                    // About
                    NavigationLink(destination: AboutView()) {
                        SettingsButton(title: "About", iconName: "info.circle")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    // Handle logout logic first
                    logoutUser()
                    
                    // After logout logic, trigger navigation to the login screen
                    navigateToLogin = true
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
    func logoutUser() {
        appState.logout()
    }
}

struct SettingsButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.primary)
                .font(.system(size: 30))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
