import ModelsKit
import SwiftData

@Model
public final class SDProductEntity {
    @Attribute(.unique)
    public var id: UInt32
    public var title: String
    public var categories: [SDCategoryEntity]
    @Relationship(inverse: \SDImageEntity.product)
    public var images: [SDImageEntity]?
    public var attributes: [String: [String]]
    public var link: String
    public var isFavourite: Bool
    
    public init(
        id: UInt32,
        title: String,
        categories: [SDCategoryEntity] = [],
        images: [SDImageEntity]? = nil,
        attributes: [String: [String]],
        link: String,
        isFavourite: Bool
    ) {
        self.id = id
        self.title = title
        self.categories = categories
        self.images = images
        self.attributes = attributes
        self.link = link
        self.isFavourite = isFavourite
    }
}

extension SDProductEntity {
    func productModel() -> ProductModel {
        let images = images?.compactMap { $0.imageModel() }
        
        return ProductModel(
            id: id,
            title: title,
            categories: categories.map { $0.categoryModel() },
            images: images,
            attributes: attributes.map { .init(name: $0.key, value: $0.value) },
            link: link,
            isFavourite: isFavourite
        )
    }
}
