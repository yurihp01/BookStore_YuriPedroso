import Foundation

struct Books: Codable, Hashable {
    var items: [Book]
}

struct Book: Identifiable, Codable, Equatable, Hashable {
    let volumeInfo: VolumeInfo
    let id: String
    var image: String?
    var title: String { volumeInfo.title }
    
    
    var isFavorite: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "favorite_\(id)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favorite_\(id)")
        }
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.volumeInfo.title == rhs.volumeInfo.title && lhs.volumeInfo.authors?.joined(separator: ", ") == rhs.volumeInfo.authors?.joined(separator: ", ")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(volumeInfo.title)
        hasher.combine(volumeInfo.authors?.joined(separator: ", "))
    }
}
