//
//  RequestTokenResponse.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation


struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
