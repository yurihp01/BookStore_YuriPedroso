import Combine
import XCTest
@testable import BookStore

class MockBookStoreService: BookStoreServiceProtocol {
    var shouldReturnError = false
    func getBooks(page: Int) -> AnyPublisher<Books, Error> {
        return if shouldReturnError {
            Fail(error: ServiceError.invalidResponse).eraseToAnyPublisher()
        } else {
            Just(MockData().loadBooksFromJSON()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func getImage(from url: String) -> AnyPublisher<UIImage, Error> {
        return Just(UIImage()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
