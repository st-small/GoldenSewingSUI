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
    
    public init(
        id: UInt32,
        title: String,
        categories: [SDCategoryEntity] = [],
        images: [SDImageEntity]? = nil
    ) {
        self.id = id
        self.title = title
        self.categories = categories
        self.images = images
    }
}

extension SDProductEntity {
    func productModel() -> ProductModel {
        let images = images?.compactMap { $0.imageModel() }
        
        return ProductModel(
            id: id,
            title: title,
            categories: categories.map { $0.categoryModel() },
            images: images
        )
    }
}
