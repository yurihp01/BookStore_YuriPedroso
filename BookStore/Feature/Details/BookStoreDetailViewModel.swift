import Foundation

protocol BookStoreDetailViewModelProtocol {
    var book: Book { get }
}

final class BookStoreDetailViewModel: BookStoreDetailViewModelProtocol {
    var book: Book

    init(book: Book) {
        self.book = book
    }
}
