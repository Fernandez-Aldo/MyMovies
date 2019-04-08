//
//  Login.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation


struct LoginRequest: Codable {
    let userName: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password
        case requestToken = "request_token"
    }
}
