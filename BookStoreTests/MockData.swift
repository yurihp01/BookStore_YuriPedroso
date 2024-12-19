import Foundation
@testable import BookStore

enum MockError: Error {
    case networkError
}

struct MockData {
    func loadBooksFromJSON() -> Books {
        do {
            guard let url = Bundle.main.url(forResource: "books", withExtension: "json") else { return Books(items: []) }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var books: Books = try decoder.decode(Books.self, from: data)
            books.items.sort(by: { $0.title < $1.title })
            return books
        } catch {
            return Books(items: []) }
        }
}
