import Combine
import UIKit

// MARK: - ViewModel Protocol
protocol BookStoreViewModelProtocol {
    var booksPublisher: Published<[Book]>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    var isFilteringFavorites: Bool { get }
    
    func toggleFavorites()
    func getBooks()
}

// MARK: - ViewModel Class
final class BookStoreViewModel {
    var isFilteringFavorites = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var filteredBooks = [Book]()
    private var service: BookStoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var page = 0
    private var hasMorePages = true
    private var books = Set<Book>()
    
    init(service: BookStoreServiceProtocol) {
        self.service = service
    }
}

// MARK: - ViewModel Protocol Impl
extension BookStoreViewModel: BookStoreViewModelProtocol {
    var booksPublisher: Published<[Book]>.Publisher { $filteredBooks }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    func getBooks() {
        guard hasMorePages, !isLoading else { return }
        isLoading = true
        
        service.getBooks(page: page)
            .map { $0.items }
            .flatMap { books in
                Publishers.MergeMany(books.map { book in
                    let thumbnail = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http:", with: "https:") ?? ""
                    return self.service.getImage(from: thumbnail)
                        .map { self.createBook(book: book, image: $0) }
                })
            }
            .collect()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(let error): self?.error = error
                }
            }, receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.books.formUnion(books)
                self.applyFilter()
                if !books.isEmpty {
                    self.page += 1
                }
            }).store(in: &cancellables)
    }
    
    func toggleFavorites() {
        isFilteringFavorites.toggle()
        applyFilter()
    }
}

// MARK: - ViewModel Private Ext
private extension BookStoreViewModel {
    func createBook(book: Book, image: UIImage) -> Book {
        Book(volumeInfo: book.volumeInfo, id: book.id, image: convertImageToBase64(image: image) ?? "")
    }
    
    func applyFilter() {
        if books.isEmpty {
            hasMorePages = false
        } else {
            filteredBooks = isFilteringFavorites ? Array(books).filter { $0.isFavorite } : Array(books)
            filteredBooks.sort(by: { $0.title < $1.title })
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }
        return imageData.base64EncodedString()
    }
}
