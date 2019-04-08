//
//  TheMDBAPI .swift
//  MyMovies
//
//  Created by MAC Consultant on 4/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation



let apiKey = "cb87e1ebfcb87bc9453cdce7b2a29f72"

struct Auth {
    static var accountId = 0
    static var requestToken = ""
    static var sessionId = ""
}


enum Endpoints {
    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=\(apiKey)"
    
    case getWatchlist
    case getRequestToken
    case login
    case createSessionId
    case webAuth
    case logout
    case getFavourites
    case search(String)
    case markWatchList
    case markFavourite
    case posterImageURL(String)
    
    var stringValue: String {
        switch self {
        case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .getRequestToken:
            return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
        case .login:
            return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
        case .createSessionId:
            return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
        case .webAuth:
            return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=mymovies:authenticate"
        case .logout:
            return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
        case .getFavourites:
            return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
        case .search(let query):
            return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .markWatchList:
            return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=" + Auth.sessionId
        case .markFavourite:
            return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=" + Auth.sessionId
        case .posterImageURL(let posterPath):
            return "https://image.tmdb.org/t/p/w500/" + posterPath
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
