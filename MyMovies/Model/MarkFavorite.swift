//
//  MarkFavorite.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation


struct MarkFavourite: Codable {
    let mediaType: String
    let mediaId: Int
    let favourite: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favourite = "favorite"
    }
}
