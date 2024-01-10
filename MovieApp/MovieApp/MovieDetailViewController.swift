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
    
    @IBOutlet weak var deneme: UIStackView!
    @IBOutlet weak var deneme2: UIStackView!
    @IBOutlet weak var deneme3: UIStackView!
    
    @IBOutlet weak var deneme4: UIStackView!
    
    @IBOutlet weak var deneme5: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLineUnderStackView(deneme)
        addLineUnderStackView(deneme2)
        addLineUnderStackView(deneme3)
        addLineUnderStackView(deneme4)
        addLineUnderStackView(deneme5)
    }

    func addLineUnderStackView(_ stackView: UIStackView) {
        let line = UIView()
        line.backgroundColor = UIColor(red: 78/255, green: 83/255, blue: 86/255, alpha: 1.0)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(line)
        
        NSLayoutConstraint.activate([
            line.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
            line.heightAnchor.constraint(equalToConstant: 2)
        ])
    }


    
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
    }
}
