//
//  IngredientTableViewCell.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 6/4/2023.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {


    @IBOutlet weak var ingredientLabel: UILabel!
    
    @IBOutlet weak var ingredientDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
