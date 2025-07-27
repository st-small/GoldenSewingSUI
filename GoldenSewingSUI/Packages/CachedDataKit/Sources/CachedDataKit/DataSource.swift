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
	func loadGeraldika() -> ProductModel?
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
	
	public func loadGeraldika() -> ProductModel? {
		guard
			let resourceFile = Bundle.module.url(
				forResource: "geraldika",
				withExtension: "json"),
			let geraldikaData = try? Data(contentsOf: resourceFile),
			let geraldika = try? JSONDecoder().decode([String].self, from: geraldikaData)
		else {
			print("🔴 \(CachedDataKitError.geraldikaDataFileMissing)")
			return nil
		}
		
		let images = geraldika.map {
			ImageModel(
				id: ImageID(UInt32.random(in: 0...1000)),
				link: $0
			)
		}
		
		return ProductModel(
			id: UInt32(0),
			title: "",
			categories: [
				CategoryModel(id: 0)
			],
			images: images,
			attributes: [],
			link: "",
			isFavourite: false
		)
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
