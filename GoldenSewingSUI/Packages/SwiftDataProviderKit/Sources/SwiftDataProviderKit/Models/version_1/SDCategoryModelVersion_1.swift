import Foundation
import ModelsKit
import SwiftData

public typealias SDCategoryModel = SchemaVersion_1.SDCategoryModel
public typealias SDPostModel = SchemaVersion_1.SDPostModel

extension SchemaVersion_1 {
    @Model
    public final class SDCategoryModel {
        @Attribute(.unique)
        public var id: UInt32
        public var title: String
        public var link: String
        public var isFavorite: Bool
        public var posts: [SDPostModel] = []
        
        public init(
            id: UInt32,
            title: String,
            link: String,
            isFavourite: Bool,
            posts: [SDPostModel] = []
        ) {
            self.id = id
            self.title = title
            self.link = link
            self.isFavorite = isFavourite
            self.posts = posts
        }
    }
    
    @Model
    public final class SDPostModel {
        @Attribute(.unique)
        public var id: UInt32
        public var title: String
        
        @Relationship(inverse: \SDCategoryModel.posts)
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

extension SchemaVersion_1.SDPostModel {
    func map() -> PostModel {
        PostModel(
            id: UInt32(id),
            title: title,
            categories: categories.map { $0.map() }
        )
    }
}
