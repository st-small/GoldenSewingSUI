import Constants

public struct CategoryID: Hashable, Decodable, Sendable {
    public init(_ value: UInt32) {
        self.value = value
    }

    public let value: UInt32
}

public struct CategoryModel: Decodable, Identifiable, Hashable {
    public let id: CategoryID
    public let title: String
    public let link: String
    
    // Temporary
    public let isFavourite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, link
        case title = "name"
        case isFavourite
    }
    
    public init(
        id: UInt32,
        title: String,
        link: String,
        isFavourite: Bool = false
    ) {
        self.id = CategoryID(id)
        self.title = title
        self.link = link
        self.isFavourite = isFavourite
    }
    
    public init(id: UInt32) {
        let title = Category.title(id)
        
        self.id = CategoryID(id)
        self.title = title
        self.link = ""
        self.isFavourite = false
    }
    
    public init(from decoder: any Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let categoryIDValue = try container.decode(UInt32.self, forKey: .id)
            self.id = CategoryID(categoryIDValue)
            self.title = try container.decode(String.self, forKey: .title)
            self.link = try container.decode(String.self, forKey: .link)
            self.isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite)
        } catch {
            print("Error \(error)")
            preconditionFailure()
        }
    }
}

extension CategoryModel: Equatable { }
