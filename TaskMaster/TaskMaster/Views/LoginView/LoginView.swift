//
//  LoginView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Header()
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    VStack(spacing: 15) {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $viewModel.passwordHash)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()

                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()

                    // Navigate to ContentView when logged in
                    .navigationDestination(isPresented: $appState.isLoggedIn) {
                        ContentView()
                    }
                }
                .onChange(of: appState.isLoggedIn) {_, newValue in
                    
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
