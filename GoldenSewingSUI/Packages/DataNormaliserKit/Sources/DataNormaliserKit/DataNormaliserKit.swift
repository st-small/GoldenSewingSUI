import CachedDataKit
import ModelsKit
import NetworkKit
import SwiftDataProviderKit

public final class DataNormaliser {
    
    private let network = NetworkService()
    private var inProgress: Bool = false
    
    private let cache: DataSourceProtocol
    private let swiftData: DataProviderProtocol
    
    public init(
        cache: DataSourceProtocol,
        swiftData: DataProviderProtocol
    ) {
        self.cache = cache
        self.swiftData = swiftData
    }
    
    public func start() async {
        guard !inProgress else { return }
        inProgress = true
        
        defer { inProgress = false }
        
        await checkCategories()
        await checkPosts()
    }
    
    private func checkCategories() async {
        let _ = swiftData.categoriesPublisher.sink { sdCategories in
            if sdCategories.isEmpty {
                Task.detached {
                    let cachedCategories = await self.loadCategoriesFromCache()
                    await self.swiftData.addCategories(cachedCategories)
                }
            }
        }
        
        await normaliseCategories()
    }
    
    private func checkPosts() async {
        let _ = swiftData.postsPublisher.sink { sdPosts in
            if sdPosts.isEmpty {
                Task.detached {
                    let cachedPosts = await self.loadPostsFromCache()
                    await self.swiftData.addPosts(cachedPosts)
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
    
    private func normalisePosts() async { }
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

// MARK: - Posts
extension DataNormaliser {
    private func loadPostsFromCache() async -> [PostModel] {
        await withCheckedContinuation { continuation in
            cache.loadPosts(dataLoading: nil) { result in
                switch result {
                case let .success(posts):
                    continuation.resume(returning: posts)
                case let .failure(error):
                    preconditionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadPostsAPI() async -> [PostModel] {
        return []
    }
}
