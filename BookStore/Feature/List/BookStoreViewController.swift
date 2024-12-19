import UIKit
import Combine

// MARK: - ViewController Class
final class BookStoreViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var viewModel: BookStoreViewModelProtocol?
    weak var coordinator: BookStoreCoordinator?
    private var cancellables = Set<AnyCancellable>()
    private var books = [Book]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
        tableView.tableFooterView = activityIndicator
        view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBooks()
    }
    
    @objc func toggleFavorites(sender: UIBarButtonItem) {
        guard !activityIndicator.isAnimating else { return }
        
        viewModel?.toggleFavorites()
        title = title == "Book Store" ? "Favorite Books" : "Book Store"
        sender.title = title == "Book Store" ? "Favorites" : "All Books"
    }
}

// MARK: - Private Extension
private extension BookStoreViewController {
    func setupViews() {
        view.backgroundColor = .white
        title = "Book Store"
        let filterButton = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(toggleFavorites))
        navigationItem.rightBarButtonItem = filterButton
        bind()
    }
    
    func bind() {
        viewModel?.booksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                self?.books = books
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel?.errorPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    func getBooks() {
        guard !activityIndicator.isAnimating else { return }
        viewModel?.getBooks()
    }
    
    func convertBase64ToImage(base64String: String?) -> UIImage? {
        guard let base64String = base64String, let imageData = Data(base64Encoded: base64String) else {
            return UIImage(named: "")
        }
        return UIImage(data: imageData)
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView Protocols
extension BookStoreViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            fatalError("Cell should be of type BookCell")
        }
        cell.configure(title: book.title, thumbnail: convertBase64ToImage(base64String: book.image))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToDetails(book: books[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffset + frameHeight >= contentHeight - 100 {
            getBooks()
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last else { return }
        if lastIndexPath.row == books.count - 1 {
            getBooks()
        }
    }
}
