import Foundation

struct CategoryDTO: Equatable, Identifiable, Codable {
    let id: Int32
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
    }
    
    init(id: Int32, title: String) {
        self.id = id
        self.title = title
    }
    
    init(from object: Category) {
        self.id = object.id
        self.title = object.title ?? "Unexpected title"
    }
}

extension CategoryDTO {
    static let mock = Self(id: 5, title: "Mitres")
}
