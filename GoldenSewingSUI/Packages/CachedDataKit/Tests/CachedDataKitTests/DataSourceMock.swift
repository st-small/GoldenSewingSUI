@testable import CachedDataKit
import ModelsKit

public final class DataSourceMock: DataSourceProtocol {
    public init() {}

    public func loadCategories(
        dataLoading _: DataLoadingFunction? = DataLoader.loadData,
        _ handler: @escaping Handler<[CategoryModel], CachedDataKitError>
    ) {
        handler(.success([
            CategoryModel(id: Int32(1), title: "", link: ""),
            CategoryModel(id: Int32(3), title: "", link: ""),
            CategoryModel(id: Int32(5), title: "", link: ""),
        ]))
    }

    public func loadPosts(
        dataLoading _: DataLoadingFunction?,
        _ handler: @escaping Handler<[ModelsKit.PostModel], CachedDataKitError>
    ) {
        handler(.success([
            PostModel(id: UInt32(1)),
            PostModel(id: UInt32(3)),
            PostModel(id: UInt32(5)),
        ]))
    }
}
