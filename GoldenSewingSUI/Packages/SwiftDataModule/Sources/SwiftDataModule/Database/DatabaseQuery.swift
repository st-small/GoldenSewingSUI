import Foundation
import ModelsKit
import SwiftData


public protocol DataQueryProtocol {
    // Categories
    func addCategories(_ categories: [CategoryModel]) async throws
    func getCategories() async throws -> [CategoryModel]
    
    // Products
    func addProducts(_ products: [ProductModel]) async throws
    func getProducts() async throws -> [ProductModel]
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
    
    public func getCategories() async throws -> [CategoryModel] {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        return try modelContext.fetch(FetchDescriptor<SDCategoryEntity>())
            .map { $0.categoryModel() }
    }
    
    // MARK: - Product
    public func addProducts(_ products: [ProductModel]) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        let productEntities = products.map { SDProductEntity($0) }
        productEntities.forEach { entity in
            modelContext.insert(entity)
        }
        try modelContext.save()
    }
    
    public func getProducts() async throws -> [ProductModel] {
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
