//
//  DrawerViewController.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 7/5/2023.
//

import UIKit

class DrawerViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a button or gesture recognizer to dismiss the drawer
    }
    
    @IBAction func dismissDrawer(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }

}
