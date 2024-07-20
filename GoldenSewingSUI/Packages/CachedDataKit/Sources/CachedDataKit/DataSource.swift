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
}

public final class DataLoader {
    public static func loadData(
        from: Resource,
        handler: @escaping Handler<Data, CachedDataKitError>
    ) {
        guard let resourceFile = Bundle.module.url(
            forResource: from.filename,
            withExtension: "json"
        ) else {
            handler(.failure(.categoriesDataFileMissing))
            return
        }
        
        do {
            let data = try Data(contentsOf: resourceFile)
            handler(.success(data))
        } catch {
            handler(.failure(.categoriesDataFileMissing))
        }
    }
}

public final class DataSourceMock: DataSourceProtocol {
    public init() { }
    
    public func loadCategories(
        dataLoading: DataLoadingFunction? = DataLoader.loadData,
        _ handler: @escaping Handler<[CategoryModel], CachedDataKitError>
    ) {
        handler(.success([
            CategoryModel(id: Int32(1), title: "", link: ""),
            CategoryModel(id: Int32(3), title: "", link: ""),
            CategoryModel(id: Int32(5), title: "", link: ""),
        ]))
    }
}
