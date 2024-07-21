import Foundation
import ModelsKit
import SwiftData

public typealias SDCategoryModel = SchemaVersion_1.SDCategoryModel
public typealias SDPostModel = SchemaVersion_1.SDPostModel

extension SchemaVersion_1 {
    @Model
    public final class SDCategoryModel {
        @Attribute(.unique)
        public var id: Int32
        public var title: String
        public var link: String
        public var isFavorite: Bool
        
        public init(
            id: Int32,
            title: String,
            link: String,
            isFavourite: Bool
        ) {
            self.id = id
            self.title = title
            self.link = link
            self.isFavorite = isFavourite
        }
    }
    
    @Model
    public final class SDPostModel {
        @Attribute(.unique)
        public var id: UInt32
        public var title: String
        
        init(
            id: UInt32,
            title: String
        ) {
            self.id = id
            self.title = title
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
        PostModel(id: UInt32(id), title: title)
    }
}
