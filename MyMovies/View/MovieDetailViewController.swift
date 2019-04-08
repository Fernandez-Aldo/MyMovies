//
//  MovieDetailViewController.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteFavBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteListBarButtonItem: UIBarButtonItem!
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        imageView.image = UIImage(named: "PosterPlaceholder")
        TheDBUser.downloadPosterImage(posterPath: movie.posterPath ?? "", completionHandler: handleDownloadPosterImage(data:error:))
        
    }
    
    private func handleDownloadPosterImage(data: Data?, error: Error?) {
        guard let data = data else {
            return
        }
        
        if let image = UIImage(data: data) {
            imageView.image = image
        }
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TheDBUser.markWatchlist(movieId: movie.id, watchlist: !isWatchlist, compltionHandler: hanldeMarkWatchlistResponse(success:error:))
    }
    
    
    @IBAction func deleteListButtonTapped(_ sender: UIBarButtonItem) {
        TheDBUser.deleteWatchlist(movieId: movie.id, watchlist: false, compltionHandler: hanldeMarkWatchlistResponse(success:error:))
    }
    
    private func hanldeMarkWatchlistResponse(success: Bool, error: Error?) {
        if success {
            if isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter { $0 != self.movie }
            } else {
                MovieModel.watchlist.append(movie)
            }
            toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
            
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
        TheDBUser.markFavourite(movieID: movie.id, markFavouture: !isFavorite, completionHandler: handleFavouriteListResponse(success:error:))
    }
    
    @IBAction func deleteFavButtonTapped(_ sender: UIBarButtonItem) {
        
        TheDBUser.deleteFavourite(movieID: movie.id, markFavouture: !isFavorite, completionHandler: handleFavouriteListResponse(success:error:))
    }
    
    
    
    private func handleFavouriteListResponse (success: Bool, error: Error?) {
        if success {
            if isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter { $0 != self.movie}
            } else {
                MovieModel.favorites.append(movie)
            }
            
            toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
            
        }
    }
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.green
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    
}
