import Foundation
import ModelsKit
import SwiftData

public typealias SDCategoryModel = SchemaVersion_1.SDCategoryModel
public typealias SDProductModel = SchemaVersion_1.SDProductModel

extension SchemaVersion_1 {
    @Model
    public final class SDCategoryModel {
        @Attribute(.unique)
        public var id: UInt32
        public var title: String
        public var link: String
        public var isFavorite: Bool
        @Relationship(inverse: \SDProductModel.categories)
        public var posts: [SDProductModel] = []
        
        public init(
            id: UInt32,
            title: String,
            link: String,
            isFavourite: Bool,
            posts: [SDProductModel] = []
        ) {
            self.id = id
            self.title = title
            self.link = link
            self.isFavorite = isFavourite
            self.posts = posts
        }
        
        public init(_ model: CategoryModel) {
            self.id = model.id.value
            self.title = model.title
            self.link = model.link
            self.isFavorite = model.isFavourite ?? false
        }
    }
    
    @Model
    public final class SDProductModel {
        @Attribute(.unique)
        public var id: UInt32
        public var title: String
        public var categories: [SDCategoryModel]
        
        init(
            id: UInt32,
            title: String,
            categories: [SDCategoryModel] = []
        ) {
            self.id = id
            self.title = title
            self.categories = categories
        }
    }
}

extension SchemaVersion_1.SDCategoryModel {
    func map() -> CategoryModel {
        CategoryModel(id: id, title: title, link: link)
    }
}

extension SchemaVersion_1.SDProductModel {
    func map() -> ProductModel {
        ProductModel(
            id: UInt32(id),
            title: title,
            categories: categories.map { $0.map() }
        )
    }
}
