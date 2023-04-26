//
//  Recette.swift
//  EasyKitchen
//
//  Created by Apple Esprit on 3/4/2023.
//

import Foundation

struct Recette:Codable{
    let _id:String
    let name:String
    let description:String
    let image:String
    let isBio:Bool
    let duration:Int
    let person:Int
    let difficulty:String
    let likes:Int
    let dislikes:Int
    let usersLiked:[String]
    let usersDisliked:[String]
    let comments:[String]
    let user:[String]
    let username:String
    
    
}
