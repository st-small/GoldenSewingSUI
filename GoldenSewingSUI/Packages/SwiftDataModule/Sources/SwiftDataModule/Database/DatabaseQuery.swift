import ModelsKit
import SwiftData


public protocol DataQueryProtocol {
    // Categories
    func addCategories(_ categories: [CategoryModel]) async throws
    func getCategories() async throws -> [SDCategoryEntity]
    
    // Products
    
    // Images
}

public struct DatabaseQuery: DataQueryProtocol {
    public init() { }
    
    public func addCategories(_ categories: [CategoryModel]) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        let categoryEntities = categories.map { SDCategoryEntity($0) }
        categoryEntities.forEach { entity in
            modelContext.insert(entity)
        }
        try modelContext.save()
    }
    
    public func getCategories() async throws -> [SDCategoryEntity] {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        return try modelContext.fetch(FetchDescriptor<SDCategoryEntity>())
    }
}
