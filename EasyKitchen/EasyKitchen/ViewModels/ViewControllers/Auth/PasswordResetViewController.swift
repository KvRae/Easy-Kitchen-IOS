//
//  PasswordResetViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/4/2023.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var passwordComfInput: UITextField!
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let password = passwordInput.text, let passworConfirm = passwordComfInput.text {
            if password.isEmpty,passworConfirm.isEmpty {
                showAlert(title: "Error", msg: "fill the password inputs")
            }else{
                if isValidPassword(password: password), password==passworConfirm{
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {self.navigationController?.pushViewController(viewController, animated: true)}
                }else{
                    showAlert(title: "Error", msg: "your password is shorter than 6 digits or not same as confirm one")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func isValidPassword(password : String)-> Bool {return password.count > 5}
    
    
    func showAlert(title: String ,msg : String) {
        
        let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
