import Foundation

public struct ProductID: Hashable, Decodable {
    public init(_ value: UInt32) {
        self.value = value
    }

    public let value: UInt32
}

public struct ProductModel: Decodable, Identifiable {
    public let id: ProductID
    public let title: String
    public let categories: [CategoryModel]
    public let images: [ImageModel]?
    
    public init(
        id: UInt32,
        title: String,
        categories: [CategoryModel],
        images: [ImageModel]? = nil
    ) {
        self.id = ProductID(id)
        self.title = title
        self.categories = categories
        self.images = images
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categories
        case betterFeaturedImage = "better_featured_image"
        case acf
    }
    
    public init(from decoder: any Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let categoryIDValue = try container.decode(UInt32.self, forKey: .id)
            self.id = ProductID(categoryIDValue)
            self.title = try container.decode(TitleModel.self, forKey: .title).rendered
            self.categories = try container.decode([UInt32].self, forKey: .categories)
                .map { CategoryModel(id: $0) }
            
            var resultImages = [ImageModel]()
            if let mainImage = try container.decodeIfPresent(BetterFeaturedImage.self, forKey: .betterFeaturedImage)?.image {
                resultImages.append(mainImage)
            }
            
            if let acf = try? container.decodeIfPresent(ACF.self, forKey: .acf)?.asImages {
                resultImages.append(contentsOf: acf)
            }
            
            self.images = resultImages
        } catch {
            print("Error \(error)")
            preconditionFailure()
        }
    }
}

extension ProductModel: Equatable, Hashable { }

struct ACF: Decodable {
    let images: [SubImageModel]
    
    enum CodingKeys: String, CodingKey {
        case images = "add_img"
    }
    
    var asImages: [ImageModel] {
        images.map { ImageModel(id: $0.id, link: $0.link) }
    }
}

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


