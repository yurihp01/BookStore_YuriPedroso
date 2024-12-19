import XCTest
import UIKit
import Combine
@testable import BookStore

class BookStoreViewControllerTests: XCTestCase {
    var viewController: BookStoreViewController!
    var mockViewModel: MockBookStoreViewModel!
    var mockCoordinator: MockBookStoreCoordinator!
    
    override func setUp() {
        super.setUp()
        
        mockViewModel = MockBookStoreViewModel()
        mockCoordinator = MockBookStoreCoordinator(navigationController: UINavigationController())
        
        viewController = BookStoreViewController()
        viewController.viewModel = mockViewModel
        viewController.coordinator = mockCoordinator
        
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    func testToggleFavorites() {
        let filterButton = UIBarButtonItem()
        viewController.toggleFavorites(sender: filterButton)
        
        XCTAssertEqual(viewController.title, "Favorite Books")
        XCTAssertEqual(filterButton.title, "All Books")
    }
    
    func testGetBooksWhenTableViewIsScrolled() {
        let scrollView = UIScrollView()
        viewController.scrollViewDidScroll(scrollView)
        XCTAssertTrue(mockViewModel.getBooksCalled)
    }
}
