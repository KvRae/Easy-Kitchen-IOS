//
//  ApiService.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 13/4/2023.
//

import Foundation

class ApiService {
    
    
    func editProfile(userId: String ) {
        
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3000/api/users/"+userId)!
        print(url)

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        // Set the request body
        let params = ["oldPassword": "oldPassword", "newPassword": "newPassword"]
        
        print(params)
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
                    
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    func changePassword(userId : String, oldPassword : String, newPassword: String) {
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3000/api/users/"+userId)!
        print(url)

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Set the request body
        let params = ["oldPassword": oldPassword, "newPassword": newPassword]
        
        print(params)
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
                    
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
            
}
    
    func forgotPassword (email: String) {
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3000/api/forgot")!
        print(url)

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["email": email]
        
        print(params)
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
                    DataSignleton.shared.token = ""
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
        
    }
    
    func verifyResetCode(resetCode: String, token: String) {
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3000/api/verify")!
        print(url)

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["resetCode": resetCode, "token":token]
        
        print(params)
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
          //
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    func resetPassword(email: String, password :String) {
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3000/api/reset")!
        print(url)

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["email": email, "password":password]
        
        print(params)
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared
        
    
        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
          //
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    
    

    
    
    
}
