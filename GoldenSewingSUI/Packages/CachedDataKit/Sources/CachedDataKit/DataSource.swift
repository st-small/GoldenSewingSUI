import Foundation
import ModelsKit

public enum Resource {
    case categories
    case posts(Int)
    
    public var filename: String {
        switch self {
        case .categories:
            return "categories"
        case let .posts(page):
            return "posts_\(page)"
        }
    }
}

public typealias Handler<T, Error> = (Result<T, CachedDataKitError>) -> Void
public typealias DataLoadingFunction = (Resource, @escaping Handler<Data, Error>) -> Void

public protocol DataSourceProtocol {
    func loadCategories(
        dataLoading: DataLoadingFunction?,
        _ handler: @escaping Handler<[CategoryModel], CachedDataKitError>
    )
    
    func loadProducts() -> AsyncStream<[ProductModel]>
}

public final class DataSource: DataSourceProtocol {
    public init() { }
    
    public func loadCategories(
        dataLoading: DataLoadingFunction?,
        _ handler: @escaping Handler<[CategoryModel], CachedDataKitError>
    ) {
        let dataLoading = dataLoading ?? DataLoader.loadData
        dataLoading(.categories) { result in
            switch result {
            case let .success(categoriesData):
                do {
                    let categories = try JSONDecoder().decode([CategoryModel].self, from: categoriesData)
                    handler(.success(categories))
                } catch {
                    handler(.failure(.categoriesDataFileMissing))
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
    
    public func loadProducts() -> AsyncStream<[ProductModel]> {
        AsyncStream { continuation in
            Task {
                for page in Array(1...7) {
                    if let posts = try? await getProducts(page) {
                        continuation.yield(posts)
                    }
                }
                
                continuation.finish()
            }
        }
    }
    
    private func getProducts(_ pageIndex: Int) async throws -> [ProductModel] {
        guard let resourceFile = Bundle.module.url(
            forResource: "posts_\(pageIndex)",
            withExtension: "json"
        ) else {
            print("🔴 \(CachedDataKitError.postsDataFileMissing)")
            return []
        }
        
        let postsData = try Data(contentsOf: resourceFile)
        let posts = try JSONDecoder().decode([ProductModel].self, from: postsData)
        
        return posts
    }
}
