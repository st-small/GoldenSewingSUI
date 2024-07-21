import Foundation
import ModelsKit

public enum Resource {
    case categories
    case posts
    
    public var filename: String {
        switch self {
        case .categories:
            return "categories"
        case .posts:
            return "posts"
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
    func loadPosts(
        dataLoading: DataLoadingFunction?,
        _ handler: @escaping Handler<[PostModel], CachedDataKitError>
    )
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
    
    public func loadPosts(
        dataLoading: DataLoadingFunction?,
        _ handler: @escaping Handler<[PostModel], CachedDataKitError>
    ) {
        let dataLoading = dataLoading ?? DataLoader.loadData
        dataLoading(.posts) { result in
            switch result {
            case let .success(postsData):
                do {
                    let posts = try JSONDecoder().decode([PostModel].self, from: postsData)
                    handler(.success(posts))
                } catch {
                    handler(.failure(.postsDataFileMissing))
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
}
