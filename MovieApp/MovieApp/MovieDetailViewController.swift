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
    
   
    
    override func viewWillAppear(_ animated: Bool) {
            if let movie = movie {
                    movieName.text = movie.title
                    fetchMovieDetails(with: movie.imdbID)
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
        
    func fetchMovieDetails(with imdbID: String) {
           let apiKey = "980ee044"
           let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)"
           guard let url = URL(string: urlString) else {
               print("Geçersiz URL")
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
               if let error = error {
                   print("Hata: \(error)")
                   return
               }
               
               guard let data = data else {
                   print("Boş veri")
                   return
               }
               
               do {
                   let decoder = JSONDecoder()
                   let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                   
                   DispatchQueue.main.async {
                       self?.updateUI(with: movieDetail)
                   }
               } catch {
                   print("Hata oluştu: \(error)")
               }
           }
           task.resume()
       }
       
       func updateUI(with movieDetail: MovieDetail) {
           movieYear.text = movieDetail.year
           movieRuntime.text = movieDetail.runtime
           movieGenre.text = movieDetail.genre
           movieDirector.text = movieDetail.director
           movieActors.text = movieDetail.actors
       }
}
