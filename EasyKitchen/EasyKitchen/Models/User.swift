//
//  User.swift
//  EasyKitchen
//
//  Created by Mac Mini 1 on 12/4/2023.
//

import Foundation

struct User:Decodable {
    let _id: String
    let username: String
    let email: String
    let password: String
    let phone: String
}
