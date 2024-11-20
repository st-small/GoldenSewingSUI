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
        ],
        attributes: [
            AttributeUnwrapped(
                name: "Ткань",
                value: ["Органза", "Бархат", "Парча"]
            ),
            AttributeUnwrapped(
                name: "Способ изготовления",
                value: [
                    "Ручная вышивка",
                    "Машинная вышивка",
                    "Инкрустация бисером"
                ]
            )
        ],
        link: ""
    )
    
    static let mockNoImage = ProductModel(
        id: UInt32(111),
        title: "Икона Святого равноапостольного князя Владимира",
        categories: [
            CategoryModel(id: UInt32(4))
        ],
        attributes: [
            AttributeUnwrapped(
                name: "Ткань",
                value: ["Органза", "Бархат", "Парча"]
            ),
            AttributeUnwrapped(
                name: "Способ изготовления",
                value: [
                    "Ручная вышивка",
                    "Машинная вышивка",
                    "Инкрустация бисером"
                ]
            )
        ],
        link: ""
    )
}
