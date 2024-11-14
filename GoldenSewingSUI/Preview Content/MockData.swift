import ModelsKit
import SwiftUI

extension CategoryModel {
    static let mock = CategoryModel(
        id: UInt32(4),
        title: "Иконы",
        link: ""
    )
}

extension ProductModel {
    static let mockWithImage = ProductModel(
        id: UInt32(111),
        title: "Икона Святого равноапостольного князя Владимира",
        categories: [
            CategoryModel(id: UInt32(4))
        ],
        images: [
            ImageModel(
                id: ImageID(5),
                link: "",
                image: UIImage(resource: .sample).pngData()
            )
        ]
    )
    
    static let mockNoImage = ProductModel(
        id: UInt32(111),
        title: "Икона Святого равноапостольного князя Владимира",
        categories: [
            CategoryModel(id: UInt32(4))
        ]
    )
}
