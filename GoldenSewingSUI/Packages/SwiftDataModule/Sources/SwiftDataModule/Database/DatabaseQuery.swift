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
    func addImages(_ images: [ImageModel], context: ModelContext) async throws
    func addImageData(_ imageID: UInt32, data: Data) async throws
    func getImage(_ imageID: UInt32) async throws -> ImageModel?
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
    
    private func updateCategories(_ ids: [UInt32], product: SDProductEntity, context: ModelContext) throws {
        let predicate = #Predicate<SDCategoryEntity> { ids.contains($0.id) }
        let descriptor = FetchDescriptor(predicate: predicate)
        let categories = try context.fetch(descriptor)
        
        for category in categories {
            category.products.append(product)
            
            try context.save()
        }
    }
    
    // MARK: - Product
    public func addProducts(_ products: [ProductModel]) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        
        // Create product entity
        for product in products {
            let productEntity = SDProductEntity(
                id: product.id.value,
                title: product.title,
                categories: [],
                images: [],
                attributes: product.attributes
                    .reduce(into: [String: [String]]()) { $0[$1.name] = $1.value },
                link: product.link
            )
            
            modelContext.insert(productEntity)
            try modelContext.save()
            
            // Create product's images entities
            try await addImages(product.images ?? [], context: modelContext)
            // Update product's images with product entity
            for image in product.images ?? [] {
                if let imageEntity = try await getImageEntity(image.id.value, context: modelContext) {
                    productEntity.images?.append(imageEntity)
                }
            }
            
            // Update categories with child (product) entity
            try updateCategories(
                product.categories.map { $0.id.value },
                product: productEntity,
                context: modelContext
            )
        }
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
        
        return category.products
            .map { $0.productModel() }
            .sorted(by: { $0.id.value > $1.id.value })
    }
    
    // MARK: - Image
    public func addImages(_ images: [ImageModel], context: ModelContext) async throws {
        let imageEntities = images.compactMap { SDImageEntity($0) }
        for image in imageEntities {
            context.insert(image)
            try! context.save()
        }
    }
    
    public func addImageData(_ imageID: UInt32, data: Data) async throws {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        guard let entity = try await getImageEntity(imageID, context: modelContext) else {
            preconditionFailure()
        }
        
        entity.imageData = data
        try modelContext.save()
    }
    
    public func getImage(_ imageID: UInt32) async throws -> ImageModel? {
        let modelContext = ModelContext(DatabaseManager.shared.container)
        guard let entity = try await getImageEntity(imageID, context: modelContext) else {
            print("Error no image model entity with \(imageID) id")
            return nil
        }
        
        return entity.imageModel()
    }
    
    private func getImageEntity(_ imageID: UInt32, context: ModelContext) async throws -> SDImageEntity? {
        let predicate = #Predicate<SDImageEntity> { entity in
            entity.id == imageID
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try context.fetch(descriptor).first
    }
}
