//
//  ViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/3/2023.
//

import UIKit

class ViewController: UIViewController {
    let defaults = UserDefaults.standard
    var faceId :Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceId = defaults.bool(forKey: "faceID")
        
        
        if(faceId == true){

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "faceIDVC") as! FaceIdViewController
                self.navigationController?.pushViewController(destinationVC, animated: true)
        
            
        }else{
            let token = defaults.object(forKey: "token") as? String
            
            if let count = token?.count {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
            
        }
    }
    
    
}
