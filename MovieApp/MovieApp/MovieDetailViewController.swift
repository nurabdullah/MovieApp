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

    }
    

   
}
