//
//  Ingredient.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 6/4/2023.
//

import Foundation

struct Ingredient:Decodable, Equatable{
    let _id:String
    let strIngredient:String
    let strDescription:String?
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs._id == rhs._id &&
               lhs.strIngredient == rhs.strIngredient &&
               lhs.strDescription == rhs.strDescription
    }
    
}
