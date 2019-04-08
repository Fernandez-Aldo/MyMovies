//
//  TMDBClient.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import Foundation

class TheDBUser {
    //Download the image
    class func downloadPosterImage(posterPath: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let url = Endpoints.posterImageURL(posterPath).url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(data, nil)
            }
        }
        
        task.resume()
        
    }
    //Save favorites
    class func markFavourite(movieID: Int, markFavouture: Bool, completionHandler: @escaping (Bool, Error?) -> Void) {
        let markFavouriteList = MarkFavourite(mediaType: "movie", mediaId: movieID, favourite: true)
        
        //Make post to the DB to save favorites
        taskForPOSTRequest(url: Endpoints.markFavourite.url, responseType: TMDBResponse.self, body: markFavouriteList) { (response, error) in
            if let response = response {
                completionHandler([1, 12, 13].contains(response.statusCode), nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
      //Make a post to the DB to delete favorites
    class func deleteFavourite(movieID: Int,markFavouture: Bool, completionHandler: @escaping (Bool, Error?) -> Void) {
        let markFavouriteList = MarkFavourite(mediaType: "movie", mediaId: movieID, favourite: false)
        
        
        taskForPOSTRequest(url: Endpoints.markFavourite.url, responseType: TMDBResponse.self, body: markFavouriteList) { (response, error) in
            if let response = response {
                completionHandler([1, 12, 13].contains(response.statusCode), nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func markWatchlist(movieId: Int, watchlist: Bool, compltionHandler: @escaping (Bool, Error?) -> Void) {
        let markWatchlist = MarkWatchList(mediaType: "movie", mediaId: movieId, watchlist: true)
        
        taskForPOSTRequest(url: Endpoints.markWatchList.url, responseType: TMDBResponse.self, body: markWatchlist) { (response, error) in
            if let response = response {
                compltionHandler([1, 12, 13].contains(response.statusCode), nil)
            } else {
                compltionHandler(false, error)
            }
        }
        
    }
    
    class func deleteWatchlist(movieId: Int, watchlist: Bool, compltionHandler: @escaping (Bool, Error?) -> Void) {
        let markWatchlist = MarkWatchList(mediaType: "movie", mediaId: movieId, watchlist: false)
        
        taskForPOSTRequest(url: Endpoints.markWatchList.url, responseType: TMDBResponse.self, body: markWatchlist) { (response, error) in
            if let response = response {
                compltionHandler([1, 12, 13].contains(response.statusCode), nil)
            } else {
                compltionHandler(false, error)
            }
        }
        
    }
    
    //Get the movies
    class func seach (movieName: String, completionHandler: @escaping ([Movie], Error?) -> Void) -> URLSessionTask {
        
        let task = taskForGETRequest(url: Endpoints.search(movieName).url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
        return task
    }
    //Fetch favorites from the DB
    class func getFavourites(completionHandler: @escaping ([Movie], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getFavourites.url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
        
    }

    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
                
            } catch {
                
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
    }
    
    
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseData, nil)
                }
                
            } catch {
                
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
    class func requestToken(completionHandler: @escaping (Bool, Error?)->Void) {
        
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }

    }
    
    
    class func requestLogin(for user: LoginRequest,completionHandler: @escaping (Bool, Error?)->Void) {
        
        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: user) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    
    class func requestSessionId(completionHandler: @escaping (Bool, Error?) -> Void) {
        
        let sessionRequestBody = PostSession(requestToken: Auth.requestToken)
        
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: sessionRequestBody) { (response, error) in
            
            if let response = response {
                Auth.sessionId = response.sessionId
                completionHandler(true, nil)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    class func logout(completionHandler: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let logoutRequest = LogoutRequest(sessionId: Auth.sessionId)
        let logoutRequestBody = try! JSONEncoder().encode(logoutRequest)
        request.httpBody = logoutRequestBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data else {
                completionHandler(error)
                return
            }
            Auth.requestToken = ""
            Auth.sessionId = ""
            completionHandler(nil)
        }
        task.resume()
    }
    
}
