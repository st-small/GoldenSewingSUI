public struct PostID: Hashable, Decodable {
    public init(_ value: UInt32) {
        self.value = value
    }

    public let value: UInt32
}

public struct PostModel: Decodable {
    public let id: PostID
    public let title: String
    
    public init(id: UInt32, title: String) {
        self.id = PostID(id)
        self.title = title
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
    }
    
    public init(from decoder: any Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let categoryIDValue = try container.decode(UInt32.self, forKey: .id)
            self.id = PostID(categoryIDValue)
            self.title = try container.decode(TitleModel.self, forKey: .title).rendered ?? ""
        } catch {
            print("Error \(error)")
            preconditionFailure()
        }
    }
}

private struct TitleModel: Decodable {
    let rendered: String?
}
