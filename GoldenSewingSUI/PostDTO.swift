import Foundation

struct PostDTO: Equatable, Codable, Identifiable {
    let id: Int32
    let title: String
    let categories: [Int32]
    
    init(
        id: Int32,
        title: String,
        categories: [Int32]
    ) {
        self.id = id
        self.title = title
        self.categories = categories
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case categories
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int32.self, forKey: .id)
            
            let titleDictionary = try container.decodeIfPresent([String: String].self, forKey: .title) ?? [:]
            self.title = titleDictionary.rendered
            
            self.categories = try container.decode([Int32].self, forKey: .categories)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    init(from object: Post) {
        self.id = object.id
        self.title = object.title ?? ""
        self.categories = [object.category]
    }
}

extension PostDTO {
    static let mock = PostDTO(
        id: 777,
        title: "Икона Святого равноапостольного князя Владимира",
        categories: [5]
    )
}

extension Dictionary where Key == String, Value == String {
    var rendered: String {
        guard let renderedValue = self["rendered"] else { return "" }

        var result = renderedValue.replacingOccurrences(of: "&#171;", with: "\"")
        result = result.replacingOccurrences(of: "&#187;", with: "\"")
        
        return result
    }
}
