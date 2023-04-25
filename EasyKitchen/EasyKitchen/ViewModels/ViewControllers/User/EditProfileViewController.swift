//
//  EditProfileViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 14/4/2023.
//

import UIKit
import JWTDecode


class EditProfileViewController: UIViewController {
    var userId : String = ""
    var username : String = ""
    var email : String = ""
    var phone : String = ""
    // INPUT FILELDS
    @IBOutlet weak var UserNameInput: UITextField!
    @IBOutlet weak var PhoneInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var ConfirmEmail: UITextField!
    let defaults = UserDefaults.standard
    
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
  //      submitButtonTapped()
        // Get the values from the text fields
            guard let username = UserNameInput.text, !username.isEmpty else {
                showAlert(title: "Nom de l'utilisateur", message: "Le nom d'utilisateur ne doit pas être vide !")
                return
            }
            guard let phoneString = PhoneInput.text, let _ = Int(phoneString) else {
                showAlert(title: "Numéro de téléphone", message: "Le Numéro de téléphone ne doit pas être vide !")
                return
            }
            guard let email = EmailInput.text, !email.isEmpty else {
                showAlert(title: "Adresse Email", message: "L'Adresse Email ne doit pas être vide !")
                return
            }


            
            // Set the URL for the POST request
            let url = URL(string: "http://127.0.0.1:3000/api/users/"+userId)!

            // Create the request object
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"

            // Set the request body
            let params = ["username": username, "phone": phoneString, "email": email]
            
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
                    DispatchQueue.main.async {
                        
                        if let jsonDict = json as? [String: Any],
                           let message = jsonDict["message"] as? String {
                            self.showAlert(title: "Success", message: message)
                            self.defaults.set(jsonDict["token"], forKey: "token")

                            
                        } else {
                            print("Error: Invalid JSON format")
                        }
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
        
        /*
         if let userData = UserDefaults.standard.data(forKey: "user"),
         let user = try? JSONDecoder().decode(User.self, from: userData) {
         UserNameInput.text = user.username
         PhoneInput.text = user.phone
         EmailInput.text = user.email
         ConfirmEmail.text = ""
         }*/
        
        let token = defaults.object(forKey: "token") as? String
        
        
        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
            // access the claims in the token payload
            userId = jwt.claim(name: "userId").string!
            username = jwt.claim(name: "username").string!
            email = jwt.claim(name: "email").string!
            phone = jwt.claim(name: "phone").string!
            
            
            UserNameInput.text = username
            PhoneInput.text = phone
            EmailInput.text = email
            
            
        } else {
            // handle decoding error
        }
        
        
    }
    
    /*
    func submitButtonTapped() {
        updateUser(_id: userId, username: UserNameInput.text!, phone: PhoneInput.text!, email: EmailInput.text!)  { result in
            switch result {
            case .success(let json):
                if let message = json["message"] as? String,
                   let token = json["token"] as? String {
                    print("Message: \(message)")
                    print("Token: \(token)")
                    showAlert(title: "Success", message: message)
                    self.defaults.set(token, forKey: "token")
                    
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            
        }

        func updateUser(_id:String, username: String, phone: String, email: String/*, completion: @escaping (Result<[String: Any], Error>) -> Void*/) {
            guard !username.isEmpty else {
                showAlert(title: "Nom de l'utilisateur", message: "Le nom d'utilisateur ne doit pas être vide !")
                return
            }
            guard !phone.isEmpty, let phone = Int(phone) else {
                showAlert(title: "Numéro de téléphone de l'utilisateur", message: "Le Numéro de téléphone d'utilisateur ne doit pas être vide !")
                return
            }
            guard !email.isEmpty else {
                showAlert(title: "L'email de l'utilisateur", message: "L'email ne doit pas être vide !")
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:3000/api/users/"+_id) else {
                fatalError("Invalid URL")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            
            let params: [String: Any] = ["username": username, "phone": phone, "email": email]
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let error = NSError(domain: "com.example.api", code: 0, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completion(.success(json ?? [:]))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
     */
        
        
        func showAlert(title: String, message: String) {
            // Show alert with title and message
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
        
    
}
