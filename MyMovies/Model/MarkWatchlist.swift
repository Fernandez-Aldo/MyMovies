//
//  MarkWatchlist.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation


struct MarkWatchList: Codable {
    let mediaType: String
    let mediaId: Int
    let watchlist: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case watchlist = "watchlist"
    }
}
