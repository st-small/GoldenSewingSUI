import ModelsKit

struct CategoryViewModel: Identifiable {
    var id: CategoryID { model.id }
    let model: CategoryModel
    var items: [ProductModel] = []

    init(_ from: CategoryModel) async {
        model = from
        items = await loadItems()
    }

    private func loadItems() async -> [ProductModel] {
//        @Injected(\.dbProvider) var dbProvider
//        guard let products = try? await dbProvider.getProducts(id.value) else { return [] }
//        let shuffled = products.shuffled()
//
//        if shuffled.count > 4 {
//            let productsWithImages = shuffled.filter { $0.images != nil }
//            return Array(productsWithImages.prefix(4)).map { $0 }
//        } else {
//            let productsWithImages = shuffled.filter { $0.images != nil }
//            return productsWithImages.map { $0 }
//        }
        []
    }
}
