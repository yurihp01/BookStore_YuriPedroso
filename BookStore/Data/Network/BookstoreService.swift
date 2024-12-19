import Combine
import UIKit

// MARK: - Enum
public enum BookstoreURL {
    case books
}

extension BookstoreURL {
    public var url: String {
        switch self {
        case .books:
            return "https://www.googleapis.com/books/v1/volumes?q=pokemon"
        }
    }
}

// MARK: - Service Protocol
protocol BookStoreServiceProtocol {
    func getBooks(page: Int) -> AnyPublisher<Books, Error>
    func getImage(from url: String) -> AnyPublisher<UIImage, Error>
}

// MARK: - Service Class
final class BookStoreService: Networking {}

// MARK: - Service Protocol Impl
extension BookStoreService: BookStoreServiceProtocol {
    func getBooks(page: Int) -> AnyPublisher<Books, Error> {
        return performRequest(bookstoreURL: .books, method: .GET, page: page)
            .eraseToAnyPublisher()
    }
}
