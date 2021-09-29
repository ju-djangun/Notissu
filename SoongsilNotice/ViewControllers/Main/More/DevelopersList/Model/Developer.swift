//
//  DeveloperModel.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/29.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

struct Developer: Codable {
    let id: Int
    
    let avatarURL: String?
    let name: String?
    let login: String
    
    let bio: String?
    let company: String?
    let location: String?
    let email: String?
    
    let htmlURL: String
        
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case name
        case login
        case bio
        case company
        case location
        case email
        case htmlURL = "html_url"
    }
}
