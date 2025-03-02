import Foundation

public struct ProductID: Hashable, Decodable {
    public init(_ value: UInt32) {
        self.value = value
    }

    public let value: UInt32
}

public struct ProductModel: Decodable, Identifiable, Equatable, Hashable {
    public let id: ProductID
    public let title: String
    public let categories: [CategoryModel]
    public let images: [ImageModel]?
    public let attributes: [AttributeUnwrapped]
    public let link: String
    public var isFavourite: Bool
    
    public init(
        id: UInt32,
        title: String,
        categories: [CategoryModel],
        images: [ImageModel]? = nil,
        attributes: [AttributeUnwrapped],
        link: String,
        isFavourite: Bool
    ) {
        self.id = ProductID(id)
        self.title = title
        self.categories = categories
        self.images = images
        self.attributes = attributes
        self.link = link
        self.isFavourite = isFavourite
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categories
        case betterFeaturedImage = "better_featured_image"
        case acf
        case link
    }
    
    public init(from decoder: any Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let categoryIDValue = try container.decode(UInt32.self, forKey: .id)
            self.id = ProductID(categoryIDValue)
            self.title = try container.decode(TitleModel.self, forKey: .title).rendered
            self.categories = try container.decode([UInt32].self, forKey: .categories)
                .map { CategoryModel(id: $0) }
            self.link = try container.decode(String.self, forKey: .link)
            self.isFavourite = false
            
            var resultImages = [ImageModel]()
            if var mainImage = try container.decodeIfPresent(BetterFeaturedImage.self, forKey: .betterFeaturedImage)?.image {
                mainImage.isMain = true
                resultImages.append(mainImage)
            }
            
            let acf = try container.decodeIfPresent(ACF.self, forKey: .acf)
            
            // ACF Images
            if let images = acf?.asImages {
                resultImages.append(contentsOf: images)
            }
            self.images = resultImages
            
            // ACF Attributes
            attributes = acf?.asAttributes ?? []
        } catch {
            print("Error \(error)")
            preconditionFailure()
        }
    }
}
