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
    }
    
    private func checkCategories() async {
        let _ = swiftData.categoriesPublisher.sink { sdCategories in
            if sdCategories.isEmpty {
                Task.detached {
                    let cachedCategories = await self.loadCategoriesFromCache()
                    cachedCategories.forEach {
                        _ = self.swiftData.addCategory($0.id, title: $0.title, link: $0.link)
                    }
                }
            }
        }
        
        await normaliseCategories()
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
    
    private func loadCategoriesFromCache() async -> [CategoryModel] {
        await withCheckedContinuation { continuation in
            cache.loadCategories(dataLoading: nil) { result in
                switch result {
                case let .success(categories):
                    continuation.resume(returning: categories)
                case let .failure(error):
                    preconditionFailure()
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
