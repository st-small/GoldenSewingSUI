struct BetterFeaturedImage: Decodable {
    let id: UInt32
    let sourceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sourceUrl = "source_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UInt32.self, forKey: .id)
        self.sourceUrl = try container.decode(String.self, forKey: .sourceUrl)
    }
    
    var image: ImageModel {
        .init(id: .init(id), link: sourceUrl)
    }
}
