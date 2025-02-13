//
//  LoginAction.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/14/24.
//

import Foundation

struct LoginAction {
    
    let networkingManager = NetworkingManager()
    
    // Fetch all users and check if the entered username and passwordHash match
    func call(parameters: LoginRequest, completion: @escaping (Bool) -> Void) {
        
        let url = "http://localhost:8080/api/users" // Endpoint to get all users
        
        // Send a GET request to retrieve all users
        networkingManager.getRequest(url: url) { response in
            if let jsonResponse = response as? [[String: Any]] {
                
                // Iterate through the list of users
                for user in jsonResponse {
                    if let username = user["username"] as? String,
                       let storedPasswordHash = user["passwordHash"] as? String,
                       parameters.username == username,
                       parameters.passwordHash == storedPasswordHash {
                        
                        // Successful login if username and passwordHash match
                        completion(true)
                        return
                    }
                }
                
                // If no match is found, login failed
                completion(false)
            } else {
                // Failed to get a valid response from the server
                completion(false)
            }
        }
    }
}
