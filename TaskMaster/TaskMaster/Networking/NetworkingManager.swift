//
//  NetworkingManager.swift
//  TaskMaster
//
//  Manages all calls that will interact with the Spring Boot REST API
//  Created by Jared Wilson on 10/6/24.
//

import Foundation

class NetworkingManager{
    
    // Method to send a post request to the Spring Boot REST API that updates the tables
    func postRequest(url: String, json: [String: Any], completion: @escaping (Any?) -> Void) {
        
        // Check if the url is a valid url
        guard let url = URL(string: url) else{
            print("URL Error")
            return
        }
        
        // Create the URL request and initialize the method and the type of content it receives
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Serialize json object into data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(nil)
            return
        }
        
        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                print("Error sending request: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data)
                completion(jsonResponse)
            } catch {
                print("Error deserializing response: \(error)")
                completion(nil)
            }
        }
        
        
        
        task.resume()
    }
    
    // Method to send a get resquest to REST API that returns all of the values of a table
    func getRequest(url: String, completion: @escaping (Any?) -> Void){
        
        // Check if the url is a valid url
        guard let url = URL(string: url) else{
            print("URL Error")
            return
        }
                
        // Create the URL request and initialize the method and the type of content it receives
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create a datatask to receive the request
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                print("Error sending request: \(error)")
                return
            }
            
            // Unwrap the received data
            guard let data = data else {
                print("No data")
                return
            }
            
            // Deserialize received items into an array
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data)
                completion(jsonResponse)
            } catch {
                print("Error deserializing json data")
            }
        }
        
        task.resume()
    }
    
    // Method to send a DELETE request to the Spring Boot REST API to delete a user by ID
    func deleteRequest(url: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: url) else {
            print("URL Error")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Send the request using a data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending DELETE request: \(error)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(false)
                return
            }
            
            // Check if the HTTP status code is 200 (OK)
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                print("Failed to delete user")
                completion(false)
            }
        }
        task.resume()
    }
    
    func putRequest(url: String, json: [String: Any], completion: @escaping (Any?) -> Void) {
            // Check if the url is a valid url
            guard let url = URL(string: url) else {
                print("URL Error")
                return
            }
            
            // Create the URL request
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Serialize json object into data
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json)
                request.httpBody = jsonData
            } catch {
                print("Error serializing JSON: \(error)")
                completion(nil)
                return
            }
            
            // Create a data task to send the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending request: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data)
                    completion(jsonResponse)
                } catch {
                    print("Error deserializing response: \(error)")
                    completion(nil)
                }
            }
            
            task.resume()
        }
    
}
