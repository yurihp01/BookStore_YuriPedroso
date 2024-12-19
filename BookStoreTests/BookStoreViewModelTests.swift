import XCTest
import Combine
@testable import BookStore

class BookStoreViewModelTests: XCTestCase {
    var viewModel: BookStoreViewModelProtocol!
    var mockService: MockBookStoreService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockBookStoreService()
        viewModel = BookStoreViewModel(service: mockService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testGetBooksSuccess() {
        let expectation = XCTestExpectation(description: "Get books successfully")
        
        viewModel.getBooks()
        viewModel.booksPublisher
            .sink { books in
                if books.count > 0 {
                    XCTAssertEqual(books.first?.volumeInfo.title, "Billboard")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetBooksFailure() {
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Get books with error")
        
        viewModel.getBooks()
        viewModel.errorPublisher
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testToggleFavorites() {
        viewModel.toggleFavorites()
        XCTAssertTrue(viewModel.isFilteringFavorites)
        
        viewModel.toggleFavorites()
        XCTAssertFalse(viewModel.isFilteringFavorites)
    }
}
