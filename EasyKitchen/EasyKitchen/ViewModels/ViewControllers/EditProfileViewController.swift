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
    }
    
    

    override func viewDidLoad() {
        getUserData()
        UserNameInput.text = ""
        PhoneInput.text = ""
        EmailInput.text = ""
        ConfirmEmail.text = ""
        super.viewDidLoad()

     
    }
    
    func checkEmail()->Bool{
        if (ConfirmEmail.text == EmailInput.text) {return true}
        return false
    }
    
    func getUserData () {}
    
    func updateUser () {}
    
    
    

}
