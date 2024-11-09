import Foundation
import ModelsKit
import SwiftData


public protocol DataQueryProtocol {
    // Categories
    func addCategories(_ categories: [CategoryModel]) async throws
    func getAllCategories() async throws -> [CategoryModel]
    
    // Products
    func addProducts(_ products: [ProductModel]) async throws
    func getAllProducts() async throws -> [ProductModel]
    func getProducts(_ categoryID: UInt32) async throws -> [ProductModel]
    
    // Images
}

public struct DatabaseQuery: DataQueryProtocol {
    public init() { }
    
    // MARK: - Category
    public func addCategories(_ categories: [CategoryModel]) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        let categoryEntities = categories.map { SDCategoryEntity($0) }
        categoryEntities.forEach { entity in
            modelContext.insert(entity)
        }
        try modelContext.save()
    }
    
    public func getAllCategories() async throws -> [CategoryModel] {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        return try modelContext.fetch(FetchDescriptor<SDCategoryEntity>())
            .map { $0.categoryModel() }
    }
    
    private func getCategories(_ ids: [UInt32], context: ModelContext) async throws -> [SDCategoryEntity] {
        let predicate = #Predicate<SDCategoryEntity> { ids.contains($0.id) }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try context.fetch(descriptor)
    }
    
    // MARK: - Product
    public func addProducts(_ products: [ProductModel]) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        
        for product in products {
            let categoryEntities = try! await getCategories(product.categories.map { $0.id.value }, context: modelContext)
            
            let images = product.images?.compactMap { SDImageEntity($0) }
            if let images {
                for image in images {
                    modelContext.insert(image)
                    try! modelContext.save()
                }
            }
            
            let productEntity = SDProductEntity(
                id: product.id.value,
                title: product.title,
                categories: categoryEntities,
                images: images
            )
            
            modelContext.insert(productEntity)
        }

        try modelContext.save()
    }
    
    public func getAllProducts() async throws -> [ProductModel] {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        let descriptor = FetchDescriptor<SDProductEntity>()
        
        return try modelContext.fetch(descriptor).map { $0.productModel() }
    }
    
    public func getProducts(_ categoryID: UInt32) async throws -> [ProductModel] {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        let predicate = #Predicate<SDCategoryEntity> { entity in
            return entity.id == categoryID
        }
        let descriptor = FetchDescriptor<SDCategoryEntity>(predicate: predicate)
        
        guard let category = try modelContext.fetch(descriptor).first else {
            preconditionFailure()
        }
        
        return category.products.map { $0.productModel() }
    }
}
