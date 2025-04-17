import Constants

public struct CategoryID: Hashable, Decodable, Sendable {
    public init(_ value: UInt32) {
        self.value = value
    }

    public let value: UInt32
}

public struct CategoryModel: Sendable, Identifiable {
    public let id: CategoryID
    public let title: String
	public let subtitle: String
    public let link: String
	public let priority: UInt8
    
    enum CodingKeys: String, CodingKey {
        case id, link
        case title = "name"
    }
    
    public init(
        id: UInt32,
        title: String,
        link: String
    ) {
        self.id = CategoryID(id)
        self.title = title
        self.link = link
		self.subtitle = Constants.Category.subtitle(id)
		self.priority = Constants.Category.priority(id)
    }
    
    public init(id: UInt32) {
        let title = Category.title(id)
        self.id = CategoryID(id)
        self.title = title
        self.link = ""
		self.subtitle = Constants.Category.subtitle(id)
		self.priority = Constants.Category.priority(id)
    }
}

extension CategoryModel: Decodable {
	public init(from decoder: any Decoder) {
		do {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let categoryIDValue = try container.decode(UInt32.self, forKey: .id)
			self.id = CategoryID(categoryIDValue)
			self.title = try container.decode(String.self, forKey: .title)
			self.link = try container.decode(String.self, forKey: .link)
			self.subtitle = Constants.Category.subtitle(categoryIDValue)
			self.priority = Constants.Category.priority(categoryIDValue)
		} catch {
			print("Error \(error)")
			preconditionFailure()
		}
	}
}

extension CategoryModel: Equatable, Hashable { }
