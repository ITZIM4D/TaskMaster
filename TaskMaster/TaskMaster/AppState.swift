//
//  AppState.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/26/24.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    // Make AppState a singleton
    static let shared = AppState()
    
    // Track the logged-in state
    @Published var isLoggedIn = false
    @Published var currentUsername: String?
    @Published var currentUserID: Int?
    
    // Private init prevents creating multiple instances
    private init() {}
    
    private let networkingManager = NetworkingManager()
    
    // Method to log in
    func login(username: String) {
        self.isLoggedIn = true
        self.currentUsername = username
        
        let usersUrl = "http://localhost:8080/api/users"
        
        networkingManager.getRequest(url: usersUrl){ jsonResponse in
            guard let response = jsonResponse as? [[String: Any]] else {
                print("Invalid Data format in Apsstate get Request")
                return
            }
            
            // Find userID in response matching username
            DispatchQueue.main.async {
                if let userDict = response.first(where: {$0["username"] as? String == username}) {
                    
                    // Successfully found user with given username
                    if let userID = userDict["userID"] as? Int {
                        self.currentUserID = userID
                        print("UserID for \(username) is \(userID)")
                    } else {
                        print("No userID found for \(username)")
                    }
                }
            }
            
        }
    }
    
    // Method to log out
    func logout() {
        self.isLoggedIn = false
        self.currentUsername = nil
        self.currentUserID = nil
    }
}
