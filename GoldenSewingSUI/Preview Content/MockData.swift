import ModelsKit

extension CategoryModel {
    static let mock = CategoryModel(
        id: UInt32(4),
        title: "Иконы",
        link: ""
    )
}

extension PostModel {
    static let mock = PostModel(
            id: UInt32(111),
            title: "Икона Святого равноапостольного князя Владимира",
            categories: [
                CategoryModel(id: UInt32(4))
            ]
        )
}
