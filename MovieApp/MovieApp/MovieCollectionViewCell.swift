//
//  MoviewCollectionViewCell.swift
//  MovieApp
//
//  Created by Abdullah Nur on 9.01.2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var moviewImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func setup(with movie: Movie) {
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8.0
        titleLbl.text = movie.title
        
        if let posterURL = URL(string: movie.posterURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: posterURL) {
                    DispatchQueue.main.async { [weak self] in
                        guard let image = UIImage(data: data) else { return }
                        self?.moviewImageView.contentMode = .scaleAspectFit
                        self?.moviewImageView.image = image
                    }
                }
            }
        }
    }
}

