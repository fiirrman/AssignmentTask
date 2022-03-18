//
//  UserEntity.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

struct User : Codable{
    let items : [UserItems]
}

struct UserItems : Codable{
    let login : String
    let avatar_url : String
}

struct Response : Codable{
    let message : String
}
