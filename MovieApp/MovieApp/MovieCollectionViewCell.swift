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
        
        if let posterURL = URL(string: movie.posterURL), !movie.posterURL.isEmpty {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: posterURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.moviewImageView.contentMode = .scaleAspectFit
                        self?.moviewImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.moviewImageView.image = UIImage(systemName: "movieclapper")
                    }
                }
            }
        } else {
            moviewImageView.image = UIImage(systemName: "movieclapper")
        }
    }
    
    
    
}

