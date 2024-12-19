import UIKit

class BookStoreDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    let book: Book
    
    init(navigationController: UINavigationController, book: Book) {
        self.navigationController = navigationController
        self.book = book
    }
    
    func start() {
        let viewModel = BookStoreDetailViewModel(book: book)
        let controller = BookStoreDetailViewController()
        controller.coordinator = self
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
}
