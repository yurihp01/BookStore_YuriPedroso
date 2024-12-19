import UIKit

class BookStoreCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = BookStoreViewController()
        controller.coordinator = self
        controller.viewModel = BookStoreViewModel(service: BookStoreService())
        navigationController.pushViewController(controller, animated: true)
    }
    
    func goToDetails(book: Book) {
        let coordinator = BookStoreDetailCoordinator(navigationController: navigationController, book: book)
        coordinator.parentCoordinator = self
        add(coordinator)
        coordinator.start()
    }
}
