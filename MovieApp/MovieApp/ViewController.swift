import UIKit

struct Movie {
    let title: String
    let image: UIImage
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    struct Movie: Decodable {
        let title: String
        let posterURL: String
    }
    
    var movies: [Movie] = [
        //        Movie(title: "Deneme1", image: UIImage(named: "TX_Dana")!)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    
    @IBOutlet weak var movieField: UITextField!
    
    @IBAction func searchButton(_ sender: UIButton) {
        if let movieTitle = movieField.text, !movieTitle.isEmpty {
            searchMovies(with: movieTitle)
        }
    }
    
    func searchMovies(with title: String) {
        let apiKey = "980ee044"
        let urlString = "http://www.omdbapi.com/?apikey=\(apiKey)&t=\(title)"
        
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Geçersiz URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Hata: \(error)")
                return
            }
            
            guard let data = data,
                  let movieInfo = try? JSONDecoder().decode(Movie.self, from: data) else {
                print("Film verisi çözümlenemedi")
                return
            }
            
            DispatchQueue.main.async {
                self?.displayMovieInfo(movieInfo)
            }
        }
        task.resume()
    }
    
    func displayMovieInfo(_ movie: Movie) {
        movies.append(movie)
        collectionView.reloadData()
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviewCollectionViewCell", for: indexPath) as! MoviewCollectionViewCell
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 300)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.row].title)
    }
}
