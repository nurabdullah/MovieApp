//
//  MoviewCollectionViewCell.swift
//  MovieApp
//
//  Created by Abdullah Nur on 9.01.2024.
//

import UIKit

class MoviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviewImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func setup(with movie: Movie){
        moviewImageView.image = movie.image
        titleLbl.text = movie.title
    }
    
}
