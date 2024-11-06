import ModelsKit
import SwiftData

@Model
public final class SDProductEntity {
    @Attribute(.unique)
    public var id: UInt32
    public var title: String
    public var categories: [SDCategoryEntity]
    
    public init(
        id: UInt32,
        title: String,
        categories: [SDCategoryEntity] = []
    ) {
        self.id = id
        self.title = title
        self.categories = categories
    }
    
    public init(_ model: ProductModel) {
        self.id = model.id.value
        self.title = model.title
        self.categories = model.categories.map { SDCategoryEntity($0) }
    }
}

extension SDProductEntity {
    func productModel() -> ProductModel {
        ProductModel(
            id: id,
            title: title,
            categories: categories.map { $0.categoryModel() }
        )
    }
}
