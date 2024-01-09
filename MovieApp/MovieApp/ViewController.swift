//
//  ViewController.swift
//  MovieApp
//
//  Created by Abdullah Nur on 9.01.2024.
//

import UIKit

struct Movie {
    let title: String
    let image: UIImage
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let movies: [Movie] = [
    
        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Hasta")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Kuruda")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Toplam")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!),
        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!),
    
      
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }


}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviewCollectionViewCell", for: indexPath) as! MoviewCollectionViewCell
        cell.setup(with: movies[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 300)
    }
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.row].title)
    }
    
}
