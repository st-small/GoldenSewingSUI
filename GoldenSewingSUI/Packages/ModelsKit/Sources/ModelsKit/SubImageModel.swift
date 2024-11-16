public struct SubImageModel: Decodable {
    let id: ImageID
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id = "sub_img"
        case link = "sub_img_url"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UInt32.self, forKey: .id)
        self.id = ImageID(id)
        self.link = try container.decode(String.self, forKey: .link)
    }
}
