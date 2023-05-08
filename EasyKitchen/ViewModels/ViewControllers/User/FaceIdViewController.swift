//
//  FaceIdViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 5/5/2023.
//

import UIKit
import LocalAuthentication

class FaceIdViewController: UIViewController {
    let defaults = UserDefaults.standard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the back button
        navigationItem.hidesBackButton = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = defaults.object(forKey: "token") as? String

        
            
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in
                if success {
                    print("Authentication succeeded")
                    DispatchQueue.main.async {
                        
                    if let count = token?.count {

                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
                            self.navigationController?.pushViewController(destinationVC, animated: true)
                        }
                        
                        
                        
                   else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let destinationVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                    }
                }
                        
                } else {
                    print("Authentication failed")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Face ID authentication failed.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        } else {
            print("Biometric authentication is not available")
            // Add your logic to handle biometric authentication not available
        }
        
    }
        
    
    @IBAction func faceIdTapped(_ sender: Any) {
        let token = defaults.object(forKey: "token") as? String

        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in
                if success {
                    print("Authentication succeeded")
                    DispatchQueue.main.async {
                        
                        if let count = token?.count {
                            
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
                            self.navigationController?.pushViewController(destinationVC, animated: true)
                        }
                        
                        
                        
                        else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                            self.navigationController?.pushViewController(destinationVC, animated: true)
                        }
                    }
                    
                } else {
                    print("Authentication failed")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Face ID authentication failed.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        } else {
            print("Biometric authentication is not available")
            // Add your logic to handle biometric authentication not available
        }
    }
}
    

