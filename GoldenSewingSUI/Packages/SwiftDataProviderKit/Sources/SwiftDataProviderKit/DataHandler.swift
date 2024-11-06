import Foundation
import ModelsKit
import SwiftData

@ModelActor
public actor DataHandler {
    @MainActor
    public init(container: ModelContainer) {
        let modelContext = container.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = container
    }
    
    public func addCategories(_ categories: [CategoryModel]) {
        categories
            .map { SDCategoryModel($0) }
            .forEach {
                modelContext.insert($0)
            }
        save()
    }
    
    public func readCategories(predicate: Predicate<SDCategoryModel>? = nil) -> [CategoryModel] {
        fetchCategories(predicate: predicate).map { $0.categoryModel() }
    }
    public func updateCategory() throws { }
    
    public func addProducts(_ products: [ProductModel]) {
        for product in products {
            let categoryIDs = product.categories.map { $0.id.value }
            let categoryPredicate = #Predicate<SDCategoryModel> { categoryIDs.contains($0.id) }
            let categories = fetchCategories(predicate: categoryPredicate)
            
            let sdProduct = SDProductModel(
                id: product.id.value,
                title: product.title,
                categories: categories,
                image: mainImage(product),
                images: images(product)
            )
            modelContext.insert(sdProduct)
            
            save()
        }
    }
    
    public func readProducts() -> [SDProductModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<SDProductModel>())
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    public func updateProduct() throws { }
    
    private func fetchCategories(predicate: Predicate<SDCategoryModel>? = nil) -> [SDCategoryModel] {
        do {
            let descriptor = FetchDescriptor<SDCategoryModel>(predicate: predicate)
            return try modelContext.fetch(descriptor)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    private func mainImage(_ product: ProductModel) -> SDImageModel? {
        guard let image = product.image else { return nil }
        let sdImage = SDImageModel(
            id: image.id.value,
            link: image.link
        )
        
        modelContext.insert(sdImage)
        save()
        
        return sdImage
    }
    
    private func images(_ product: ProductModel) -> [SDImageModel]? {
        guard let images = product.images else { return nil }
        
        var result = [SDImageModel]()
        for image in images {
            let sdImage = SDImageModel(id: image.id.value, link: image.link)
            result.append(sdImage)
            modelContext.insert(sdImage)
        }
        save()
        
        return result
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}
