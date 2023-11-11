import Foundation

struct PostDTO: Equatable, Decodable, Identifiable {
    let id: Int32
    let date: Date?
    let modified: Date?
    let link: URL?
    let title: String
    let mainImage: Int32
    let categories: [Int32]
    let gallery: [Int32]
    
    init(
        id: Int32,
        date: Date?,
        modified: Date?,
        link: URL?,
        title: String,
        mainImage: Int32,
        categories: [Int32],
        gallery: [Int32]
    ) {
        self.id = id
        self.date = date
        self.modified = modified
        self.link = link
        self.title = title
        self.mainImage = mainImage
        self.categories = categories
        self.gallery = gallery
    }
    
    enum CodingKeys: CodingKey {
        case id, date, modified, link, title, featured_media, categories, tags, acf
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int32.self, forKey: .id)
            self.link = try container.decode(URL.self, forKey: .link)
            self.mainImage = try container.decodeIfPresent(Int32.self, forKey: .featured_media) ?? -1
            self.categories = try container.decode([Int32].self, forKey: .categories)
            
            let dateString = try container.decode(String.self, forKey: .date)
            self.date = dateString.date()
            let modifiedDateString = try container.decode(String.self, forKey: .modified)
            self.modified = modifiedDateString.date()
            
            let titleDictionary = try container.decodeIfPresent([String: String].self, forKey: .title) ?? [:]
            self.title = titleDictionary.rendered
            
            let acf = try container.decode([String: GenericDecodable].self, forKey: .acf)
            self.gallery = (acf["add_img"]?.value as? Array<[String: Any]>)?
                .compactMap { $0["sub_img"] as? NSNumber }
                .compactMap { $0 as? Int32 } ?? []
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    init(from object: Post) {
        self.id = object.id
        self.date = object.date
        self.modified = object.modified
        self.link = object.link
        self.title = object.title ?? ""
        self.mainImage = object.mainImage
        self.categories = object.categories ?? []
        self.gallery = object.gallery ?? []
    }
}

extension PostDTO {
    static let mock = PostDTO(
        id: 777,
        date: .now,
        modified: .now,
        link: URL(string: "https://zolotoe-shitvo.kr.ua/ikona-svyatogo-ravnoapostolnogo-knyazya-vladimira-2/")!,
        title: "Икона Святого равноапостольного князя Владимира",
        mainImage: 10141,
        categories: [4],
        gallery: [10140]
    )
    
    static let mock2 = PostDTO(
        id: 9914,
        date: .now,
        modified: .now,
        link: URL(string: "https://zolotoe-shitvo.kr.ua/mitra-ierejskaya-98/")!,
        title: "Митра иерейская",
        mainImage: 9915,
        categories: [6],
        gallery: [9915]
    )
}
