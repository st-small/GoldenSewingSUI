struct TitleModel: Decodable {
    let rendered: String
    
    enum CodingKeys: CodingKey {
        case rendered
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rendered = try container.decodeIfPresent(String.self, forKey: .rendered)?.htmlDecoded ?? ""
    }
}
