import CachedDataKit
import ModelsKit
import NetworkKit
import SwiftDataModule

public final class DataNormaliser {
    private let network = NetworkService()
    private var inProgress: Bool = false
    
    private let cache: DataSourceProtocol
    private let swiftData: DataQueryProtocol
    
    public init(
        cache: DataSourceProtocol,
        swiftData: DataQueryProtocol
    ) {
        self.cache = cache
        self.swiftData = swiftData
    }
    
    public func start() async {
        guard !inProgress else { return }
        inProgress = true
        
        defer { inProgress = false }
        
        await calculateTime {
            print("T!: Start check categories")
            await checkCategories()
        }
        
        await calculateTime {
            print("T!: Start check all products")
            await checkProducts()
        }
    }
    
    private func checkCategories() async {
        // TODO: Add normaliser implementation        
        let sdCategories = try! await swiftData.getAllCategories()
        if sdCategories.isEmpty {
            let cachedCategories = await self.loadCategoriesFromCache()
            try! await swiftData.addCategories(cachedCategories)
        }
        
        await normaliseCategories()
    }
    
    private func checkProducts() async {
        // TODO: Add normaliser implementation
        let sdProducts = try! await swiftData.getAllProducts()
        if sdProducts.isEmpty {
            for await cachedProducts in cache.loadProducts() {
                await calculateTime {
                    print("T!: Start check part of the products")
                    try! await swiftData.addProducts(cachedProducts)
                }
            }
        }
        
        await normalisePosts()
    }
    
    private func normaliseCategories() async {
        let apiCategories = await loadCategoriesAPI()
//        let sdCategories = swiftData.categories
        
//        apiCategories.forEach { category in
//            _ = swiftData.addCategory(
//                category.id,
//                title: category.title,
//                link: category.link
//            )
//        }
    }
    
    private func normalisePosts() async {
        print("<<< Пошел в нормализацию постов")
        // TODO: normalisePosts
    }
}

// MARK: - Categories
extension DataNormaliser {
    private func loadCategoriesFromCache() async -> [CategoryModel] {
        await withCheckedContinuation { continuation in
            cache.loadCategories(dataLoading: nil) { result in
                switch result {
                case let .success(categories):
                    continuation.resume(returning: categories)
                case let .failure(error):
                    preconditionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadCategoriesAPI() async -> [CategoryModel] {
        do {
            return try await network.sendRequest(AppEndpoint.getCategories())
        } catch {
            print("Error \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Products
extension DataNormaliser {
    private func loadPostsAPI() async -> [ProductModel] {
        return []
    }
}

// TODO: Let's mind where it should be store
import Foundation

private func calculateTime(block: () async -> Void) async {
    let start = DispatchTime.now()
    await block()
    let end = DispatchTime.now()
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    print("T!: Time: \(timeInterval) seconds")
}
