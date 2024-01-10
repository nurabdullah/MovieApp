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
    var bottomLineView: UIView!

    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            addBottomLine()
        }
    
    private func addBottomLine() {
            bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(red: 140/255, green: 156/255, blue: 165/255, alpha: 1.0)
            bottomLineView.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(bottomLineView)

            NSLayoutConstraint.activate([
                bottomLineView.heightAnchor.constraint(equalToConstant: 1),
                bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    
   
    
    func setup(with movie: Movie) {
        
        titleLbl.text = "\(movie.title) (\(movie.year))"

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

