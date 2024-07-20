import Foundation
import ModelsKit
import SwiftData

public typealias SDCategoryModel = SchemaVersion_1.SDCategoryModel

extension SchemaVersion_1 {
    @Model
    public final class SDCategoryModel {
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
}

extension SchemaVersion_1.SDCategoryModel {
    func map() -> CategoryModel {
        CategoryModel(id: id, title: title, link: link)
    }
}
