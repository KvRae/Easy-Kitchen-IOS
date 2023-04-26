//
//  EditPasswordViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/4/2023.
//

import UIKit
import JWTDecode

class EditPasswordViewController: UIViewController {
    var userId : String = ""

    //url session
    let apiService = ApiService()
    
    //INPUT FIELDS

    @IBOutlet weak var OldPasswordInput: UITextField!
    
    @IBOutlet weak var NewPasswordInput: UITextField!
    
    @IBOutlet weak var ConfirmPasswordInput: UITextField!
    let defaults = UserDefaults.standard

    // SUBMIT BUTTON
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        if confirmPassword(), fieldsNotEmpty(){
            showAlert(title: "Error", msg: "invald passwords")

        } else {
            apiService.changePassword(userId: userId,oldPassword: OldPasswordInput.text!, newPassword: NewPasswordInput.text!)}
        showAlert(title: "Confirmation", msg: "Password Changed!")

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = defaults.object(forKey: "token") as? String
        
        
        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
            // access the claims in the token payload
            userId = jwt.claim(name: "userId").string!

            
            
        } else {
            // handle decoding error
        }
        
       
    }
    
    func confirmPassword() -> Bool {
        return NewPasswordInput.text == ConfirmPasswordInput.text
    }
    
    func fieldsNotEmpty ()->Bool{
        if OldPasswordInput.text!.isEmpty, NewPasswordInput.text!.isEmpty, ConfirmPasswordInput.text!.isEmpty{return true}
        return false
    }
    
    func showAlert(title: String ,msg : String) {
        
        let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)

        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
           self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        
        //Add OK button to a dialog message
        dialogMessage.addAction(action)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    

    

}
