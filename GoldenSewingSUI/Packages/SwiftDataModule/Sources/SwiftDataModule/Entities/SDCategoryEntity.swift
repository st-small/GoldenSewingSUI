import ModelsKit
import SwiftData

@Model
public final class SDCategoryEntity {
    @Attribute(.unique)
    public var id: UInt32
    public var title: String
    public var link: String
    public var isFavorite: Bool
    @Relationship(inverse: \SDProductEntity.categories)
    public var products: [SDProductEntity] = []
    
    public init(
        id: UInt32,
        title: String,
        link: String,
        isFavourite: Bool,
        products: [SDProductEntity] = []
    ) {
        self.id = id
        self.title = title
        self.link = link
        self.isFavorite = isFavourite
        self.products = products
    }
    
    public init(_ model: CategoryModel) {
        self.id = model.id.value
        self.title = model.title
        self.link = model.link
        self.isFavorite = model.isFavourite ?? false
    }
}

public extension SDCategoryEntity {
    func categoryModel() -> CategoryModel {
        CategoryModel(id: id, title: title, link: link)
    }
}
