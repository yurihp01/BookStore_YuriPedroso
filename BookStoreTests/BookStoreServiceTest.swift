import XCTest
import Combine
@testable import BookStore

class BookStoreServiceTests: XCTestCase {
    var service: BookStoreServiceProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = BookStoreService()
        cancellables = []
    }

    override func tearDown() {
        service = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetBooks() {
        let expectation = XCTestExpectation(description: "Fetch books")
        let mockService = MockBookStoreService()
        let mockBooks = MockData().loadBooksFromJSON()
        _ = Just(mockBooks)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        mockService.getBooks(page: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): XCTFail("Error: \(error)")
                }
            }, receiveValue: { books in
                XCTAssertEqual(books.items.count, 10)
                XCTAssertEqual(books.items.first?.volumeInfo.title, "Billboard")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
