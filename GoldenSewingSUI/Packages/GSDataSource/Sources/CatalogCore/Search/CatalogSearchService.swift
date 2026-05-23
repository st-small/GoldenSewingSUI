import Dependencies
import SQLiteData

public struct CatalogSearchService: Sendable {
    /// Возвращает все категории или отфильтрованные по запросу, отсортированные по priority desc.
    public var categories: @Sendable (_ query: String) async throws -> [Category]
    /// Поиск товаров по названию/слагу с опциональным фильтром по категории.
    /// Сортировка: isBestOffer → isOffer → name.
    public var products: @Sendable (_ query: String, _ categoryId: Int32?) async throws -> [Product]
}

extension CatalogSearchService: DependencyKey {
    public static let testValue = liveValue

    public static let liveValue = CatalogSearchService(
        categories: { query in
            @Dependency(\.defaultDatabase) var db
            return try db.read { db in
                var q = Category.all
                if !query.isEmpty {
                    q = q.where { $0.name.contains(query) || $0.slug.contains(query) }
                }
                return try q.order { $0.priority.desc() }.fetchAll(db)
            }
        },
        products: { query, categoryId in
            @Dependency(\.defaultDatabase) var db
            return try db.read { db in
                var q = Product.all
                if !query.isEmpty {
                    q = q.where { $0.name.contains(query) || $0.slug.contains(query) }
                }
                if let categoryId {
                    q = q.where { $0.categoryId.eq(#bind(categoryId)) }
                }
                return try q.order { ($0.isBestOffer.desc(), $0.isOffer.desc(), $0.name) }.fetchAll(db)
            }
        }
    )
}
