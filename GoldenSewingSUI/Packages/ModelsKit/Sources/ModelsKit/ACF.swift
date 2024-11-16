struct ACF: Decodable {
    let images: [SubImageModel]
    let attributes: [Attribute]
    
    enum CodingKeys: String, CodingKey {
        case images = "add_img"
        case attributes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _ = try? container.decode(Bool.self, forKey: .images) {
            self.images = []
        } else {
            self.images = try container.decode([SubImageModel].self, forKey: .images)
        }
        
        if let _ = try? container.decode(Bool.self, forKey: .attributes) {
            self.attributes = []
        } else {
            self.attributes = try container.decode([Attribute].self, forKey: .attributes)
        }
    }
    
    var asImages: [ImageModel] {
        images.map { ImageModel(id: $0.id, link: $0.link) }
    }
    
    var asAttributes: [AttributeUnwrapped] {
        attributes
            .filter {
                $0.defaultName != "null" &&
                $0.defaultName != "price" &&
                $0.defaultName != "img" }
            .map { AttributeUnwrapped($0) }
    }
}
