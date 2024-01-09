import UIKit

struct Movie: Decodable {
    let title: String
    let posterURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case posterURL = "Poster"
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []
    
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
            movieField.text = ""
            movies.removeAll()
        }
        movies.removeAll()

    }
    
    func searchMovies(with title: String) {
        let apiKey = "980ee044"
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&t=\(title)"
        
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
            
            guard let data = data else {
                print("Boş veri")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieInfo = try decoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    self?.displayMovieInfo(movieInfo)
                }
            } catch {
                print("Hata oluştu: \(error)")
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
        let movie = movies[indexPath.item]
        cell.setup(with: movie)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 500, height: 500) 
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(movies[indexPath.row].title)
    }
}
