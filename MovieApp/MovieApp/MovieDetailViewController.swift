//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Abdullah Nur on 10.01.2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            movieName.text = movie.title
            movieYear.text = movie.year
            movieRuntime.text = movie.genre
//            movieGenre.text = movie.genre
//            movieDirector.text = movie.director
//            movieActors.text = movie.actors
            
            if let posterURL = URL(string: movie.posterURL) {
                URLSession.shared.dataTask(with: posterURL) { [weak self] (data, _, error) in
                    guard let data = data, error == nil else {
                        print("Error loading image")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.movieImage.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
}
