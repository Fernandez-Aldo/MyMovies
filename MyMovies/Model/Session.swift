//
//  SessionResponse.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
