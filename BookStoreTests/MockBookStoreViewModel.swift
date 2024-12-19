import Combine

class MockBookStoreViewModel: BookStoreViewModelProtocol {
    var isFilteringFavorites: Bool = false
    var booksPublisher: Published<[Book]>.Publisher { $books }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    @Published var books = [Book]()
    @Published var isLoading = false
    @Published var error: Error?
    
    var getBooksCalled = false
    
    func toggleFavorites() {
        isFilteringFavorites.toggle()
    }
    
    func getBooks() {
        getBooksCalled = true
    }
}

class MockBookStoreCoordinator: BookStoreCoordinator {
    var goToDetailsCalled = false
    
    override func goToDetails(book: Book) {
        goToDetailsCalled = true
    }
}
