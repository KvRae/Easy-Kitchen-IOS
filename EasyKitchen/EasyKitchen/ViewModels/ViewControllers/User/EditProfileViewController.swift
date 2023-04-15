//
//  EditProfileViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 14/4/2023.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // INPUT FILELDS
    @IBOutlet weak var UserNameInput: UITextField!
    @IBOutlet weak var PhoneInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var ConfirmEmail: UITextField!
    
    // SUBMIT BUTTON
    @IBAction func SubmitButton(_ sender: UIButton) {
        
        submitButtonTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let userData = UserDefaults.standard.data(forKey: "user"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            UserNameInput.text = user.username
            PhoneInput.text = user.phone
            EmailInput.text = user.email
            ConfirmEmail.text = ""
        }
    }

    func submitButtonTapped() {
    }

    func updateUser(userData: Data) {
        // TODO
        showAlert(title: "Success", message: "User data updated successfully.")
    }

    func showAlert(title: String, message: String) {
        // Show alert with title and message
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


}
