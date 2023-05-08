//
//  Ingredient.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 6/4/2023.
//

import Foundation

struct Ingredient:Identifiable, Codable, Equatable{
    var id = UUID()
    var _id:String
    var strIngredient:String
    var strDescription:String?
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs._id == rhs._id &&
               lhs.strIngredient == rhs.strIngredient &&
               lhs.strDescription == rhs.strDescription
    }
    
    
    
}
