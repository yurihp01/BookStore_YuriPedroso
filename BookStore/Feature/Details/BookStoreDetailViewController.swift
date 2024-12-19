import UIKit

class BookStoreDetailViewController: UIViewController {
    // MARK: - Vars
    weak var coordinator: BookStoreDetailCoordinator?
    var viewModel: BookStoreDetailViewModelProtocol?
    
    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton(frame: .init(x: 0, y: 0, width: view.frame.width - 32, height: 40))
        button.setTitle("Buy", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(frame: .init(x: 0, y: 0, width: view.frame.width - 32, height: 40))
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, descriptionLabel, buyButton, favoriteButton])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupViews()
    }
}

// MARK: - Private Functions
private extension BookStoreDetailViewController {
    func setupConstraints() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupViews() {
        guard let book = viewModel?.book else { return }
        title = "Book Details"
        titleLabel.text = "Book title: \(book.volumeInfo.title)"
        authorLabel.text = "Authors: " + (book.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown")
        descriptionLabel.text = "Description: \(book.volumeInfo.description ?? "No description available.")"
        favoriteButton.setTitle(book.isFavorite ? "Unfavorite" : "Favorite", for: .normal)

        if let buyLink = book.volumeInfo.infoLink {
            buyButton.isHidden = false
            buyButton.addAction(UIAction(handler: { [weak self] _ in
                self?.buyBook(buyLink: buyLink)
            }), for: .touchUpInside)
        } else {
            buyButton.isHidden = true
        }
    }
        
    @objc func buyBook(buyLink: String) {
        if let url = URL(string: buyLink) {
            UIApplication.shared.open(url)
        }
    }
        
    @objc func toggleFavorite() {
        guard var book = viewModel?.book else { return }
        book.isFavorite.toggle()
        favoriteButton.setTitle(book.isFavorite ? "Unfavorite" : "Favorite", for: .normal)
    }
}
