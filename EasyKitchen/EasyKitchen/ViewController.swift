//
//  ViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 15/3/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "token") as? String
        if let count = token?.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "TabBarC") as! TabBarController
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }


}

