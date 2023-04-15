//
//  EditPasswordViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/4/2023.
//

import UIKit

class EditPasswordViewController: UIViewController {
    
    //INPUT FIELDS

    @IBOutlet weak var OldPasswordInput: UITextField!
    
    @IBOutlet weak var NewPasswordInput: UITextField!
    
    @IBOutlet weak var ConfirmPasswordInput: UITextField!
    
    // SUBMIT BUTTON
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        if confirmPassword(), fieldsNotEmpty(){
            showAlert(title: "Error", msg: "invald passwords")
            
            
            //TODO get UserID from defaults
            
            //TODO url session request to https://localhost:3000/api/user/resetPassword/:id
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func confirmPassword() -> Bool {
        if (NewPasswordInput.text == ConfirmPasswordInput.text) {return true}
        return false
    }
    
    func fieldsNotEmpty ()->Bool{
        if (OldPasswordInput.text!.isEmpty || NewPasswordInput.text!.isEmpty || ConfirmPasswordInput.text!.isEmpty)
        {return true}
        
        return false
    }
    
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
