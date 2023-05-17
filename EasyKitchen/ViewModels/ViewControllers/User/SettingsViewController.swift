//
//  SettingsViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 2/5/2023.
//

import UIKit
import JWTDecode
import Kingfisher

class SettingsViewController: UIViewController {
    var userId : String = ""
    var username : String = ""
    var email : String = ""
    var phone : String = ""
    var image : String = ""

    @IBOutlet weak var faceIdSwitch: UISwitch!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var chefHatIV: UIImageView!
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
       /*
            defaults.removeObject(forKey: "token")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.navigationController?.pushViewController(destinationVC, animated: true)
*/
        
        // Remove user data from storage
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "user")
        
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
            let navVC = UINavigationController(rootViewController: rootVC)
            UIApplication.shared.windows.first?.rootViewController = navVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        },
                          completion: nil)
    }

 
 
    @IBOutlet weak var chefHatSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard

        let token = defaults.object(forKey: "token") as? String
        
        let chefHatCheck = defaults.object(forKey: "chefHat") as? Bool
        
        if (chefHatCheck == true){
            chefHatIV.isHidden = false
        }else{
            chefHatIV.isHidden = true
        }
        
        print(token)
        
        let faceID = defaults.bool(forKey: "faceID")
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.borderColor = UIColor.orange.cgColor
        
        if (faceID == true){
            faceIdSwitch.isOn = true
        }else{
            faceIdSwitch.isOn = false
        }
        
        if (chefHatCheck == true){
            chefHatSwitch.isOn = true
        }else{
            chefHatSwitch.isOn = false
        }
        let jwt = try? decode(jwt: token!)
        
        if let jwt = jwt {
            // access the claims in the token payload
            userId = jwt.claim(name: "userId").string!
            username = jwt.claim(name: "username").string!
            email = jwt.claim(name: "email").string!
            phone = jwt.claim(name: "phone").string!
            image = jwt.claim(name: "image").string!
            
            usernameLabel.text = username
            emailLabel.text = email
            phoneLabel.text = phone
            avatarImageView.kf.setImage(with: URL(string: image))
            
            
            	
        } else {
            // handle decoding error
        }

 }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func faceIdswitchTapped(_ sender: UISwitch) {
        let defaults = UserDefaults.standard

        if sender.isOn{
            defaults.set(true, forKey: "faceID")
        }else{
            defaults.set(false, forKey: "faceID")

        }
    }
    
    @IBAction func chefHatTapped(_ sender: UISwitch) {
        let defaults = UserDefaults.standard

        if sender.isOn{
            defaults.set(true, forKey: "chefHat")
            DispatchQueue.main.async {
                self.chefHatIV.isHidden =  false
            }
            
        }else{
            defaults.set(false, forKey: "chefHat")
            DispatchQueue.main.async {
                self.chefHatIV.isHidden =  true
            }
        }
        
    }
    

}
