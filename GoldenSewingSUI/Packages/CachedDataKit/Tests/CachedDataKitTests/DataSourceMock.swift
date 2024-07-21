import ModelsKit
@testable import CachedDataKit

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
    
    public func loadPosts(
        dataLoading: DataLoadingFunction?,
        _ handler: @escaping Handler<[ModelsKit.PostModel], CachedDataKitError>
    ) {
        handler(.success([
            PostModel(id: UInt32(1)),
            PostModel(id: UInt32(3)),
            PostModel(id: UInt32(5)),
        ]))
    }
}
