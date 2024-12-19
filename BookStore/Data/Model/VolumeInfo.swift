struct VolumeInfo: Codable, Hashable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let infoLink: String?
}
