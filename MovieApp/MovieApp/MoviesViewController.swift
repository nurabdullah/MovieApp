import UIKit

struct Movie: Decodable {
    let title: String
    let posterURL: String
    let imdbID: String
    let year: String

    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case posterURL = "Poster"
        case imdbID = "imdbID"
        case year = "Year"

    }
}

struct MovieDetail: Decodable {
    let title: String
    let posterURL: String
    let imdbID: String
    let year: String
    let runtime: String
    let genre: String
    let director: String
    let actors: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case posterURL = "Poster"
        case imdbID = "imdbID"
        case year = "Year"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
    }
}


struct SearchResponse: Decodable {
    let search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}



class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieSearchField: UITextField!

    var movies: [Movie] = []
    var currentPage: Int = 1
    var isFetchingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(red: 140/255, green: 156/255, blue: 165/255, alpha: 1.0)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        if let movieTitle = movieSearchField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !movieTitle.isEmpty {
            currentPage = 1
            movies.removeAll()
            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint.zero, animated: true)
            searchMoviesApiRequest(with: movieTitle, page: currentPage)
        } else {
            print("Geçersiz arama")
        }
    }
    
    func searchMoviesApiRequest(with title: String, page: Int) {
        let apiKey = "980ee044"
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(title)&page=\(page)"
        print("Aranan URL: \(urlString)")

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
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)


                DispatchQueue.main.async {
                    self?.updateMovies(with: searchResponse.search)
                    if let visibleIndexPath = self?.collectionView.indexPathsForVisibleItems.min(by: { $0.row < $1.row }) {
                        self?.collectionView.scrollToItem(at: visibleIndexPath, at: .top, animated: true)
                    }
                }
            } catch {
                print("Hata oluştu: \(error)")
            }
        }
        task.resume()
    }
    
    func updateMovies(with newMovies: [Movie]) {
        let oldCount = movies.count
        movies.append(contentsOf: newMovies)
        let indexPaths = (oldCount..<movies.count).map { IndexPath(item: $0, section: 0) }
        collectionView.insertItems(at: indexPaths)
        isFetchingData = false
    }

}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.item]
        cell.setup(with: movie)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            movieDetailVC.movie = selectedMovie
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight && !isFetchingData {
            currentPage += 1
            isFetchingData = true
            if let movieTitle = movieSearchField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !movieTitle.isEmpty {
                searchMoviesApiRequest(with: movieTitle, page: currentPage)
            }
        }
    }
}

