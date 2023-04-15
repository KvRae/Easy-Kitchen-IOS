//
//  PasswordVerificationCodeViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/4/2023.
//

import UIKit

class PasswordVerificationCodeViewController: UIViewController {
    

    @IBOutlet weak var verificationCodeInput: UITextField!
    
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let code = verificationCodeInput.text {
            if code.isEmpty {
                showAlert(title: "Error", msg: "fill te code input")
            }else{
                if isValidCode(code: code) {
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordResetVC") as? PasswordResetViewController {self.navigationController?.pushViewController(viewController, animated: true)}
                }else{
                    showAlert(title: "Error", msg: "invalid code")
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isValidCode(code : String)-> Bool {return code == "555555"}
    
    
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
