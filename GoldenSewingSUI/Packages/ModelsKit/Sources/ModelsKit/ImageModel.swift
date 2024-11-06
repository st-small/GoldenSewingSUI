import Foundation

public struct ImageID: Decodable, Hashable {
    public let value: UInt32
    
    public init(_ value: UInt32) {
        self.value = value
    }
}

public struct ImageModel: Decodable, Identifiable {
    public let id: ImageID
    public let link: String
    public var image: Data?
    
    enum CodingKeys: String, CodingKey {
        case id = "sub_img"
        case link = "sub_img_url"
    }
    
    public init(id: ImageID, link: String, image: Data? = nil) {
        self.id = id
        self.link = link
        self.image = image
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(ImageID.self, forKey: .id)
        self.link = try container.decode(String.self, forKey: .link)
    }
}

extension ImageModel: Equatable, Hashable { }
