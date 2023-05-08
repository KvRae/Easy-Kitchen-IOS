//
//  LoginViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 20/3/2023.
//

import UIKit

class LoginViewController: UIViewController {


    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
            // Get the values from the text fields

                guard let username = usernameTextField.text, !username.isEmpty else {
                    showAlert(title: "Nom de l'utilisateur", message: "Le Nom de l'utilisateur ne doit pas être vide !")
                    return
                }
                guard let password = passwordTextField.text, !password.isEmpty else {
                    showAlert(title: "Mot de passe", message: "Le Mot de passe ne doit pas être vide !")
                    return
                }

                // Set the URL for the POST request
                let url = URL(string: "http://127.0.0.1:3000/api/login")!

                // Create the request object
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                // Set the request body
                let params = ["username": username, "password": password]
                            
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
                        let defaults = UserDefaults.standard

                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let user = json["user"] as? [String: Any],
                           let username = user["username"] as? String {
                            defaults.set(json["token"], forKey: "token")
                            defaults.set(json["user"], forKey: "user")
                            DispatchQueue.main.async {
                                self.showAlertNavigate(title: "Success", message: "Welcome \(username)")
                            }
                            
                        } else {
                            print("Invalid JSON format")
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }



                }

                // Start the data task
                task.resume()
    }
    
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token") as? String
        print(token)
        if self.traitCollection.userInterfaceStyle == .dark {
            logoImageView.image = UIImage(named: "darkModeLogo")
        }

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the back button
        navigationItem.hidesBackButton = true
    }

    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertNavigate(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
           self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        alert.addAction(action)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }


}













/*                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)

                        if let jsonDictionary = json as? [String: Any], let username = jsonDictionary["user"] as? String {
                            print(jsonDictionary)
                            print(username)
                            DispatchQueue.main.async {
                                self.showAlertNavigate(title: "Success", message: "Welcome \(username)")
                            }
                        } else {
                            print("Invalid JSON format")
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }*/
