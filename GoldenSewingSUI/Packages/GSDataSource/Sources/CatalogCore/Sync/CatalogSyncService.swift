import Dependencies
import SQLiteData

public struct CatalogSyncService: Sendable {
    public var sync: @Sendable () async throws -> Void
}

extension CatalogSyncService: DependencyKey {
    public static let testValue = liveValue

    public static let liveValue = CatalogSyncService {
        @Dependency(\.defaultDatabase) var db
        let loader = JSONLoader()
        let categoryDTOs = try loader.loadCategories()
        let productDTOs = try loader.loadProducts()

        let categories = categoryDTOs.map(Category.init(from:))
        let products = productDTOs.map(Product.init(from:))

        try db.write { db in
            for cat in categories {
                try Category.insert { cat }
                    onConflict: { cols in cols.id }
                    doUpdate: { row, excluded in
                        row.name = excluded.name
                        row.slug = excluded.slug
                        row.description = excluded.description
                        row.link = excluded.link
                        row.count = excluded.count
                        row.parent = excluded.parent
                        row.priority = excluded.priority
                    }
                    .execute(db)
            }
            for product in products {
                try Product.insert { product }
                    onConflict: { cols in cols.id }
                    doUpdate: { row, excluded in
                        row.name = excluded.name
                        row.slug = excluded.slug
                        row.link = excluded.link
                        row.date = excluded.date
                        row.categoryId = excluded.categoryId
                        row.imageURL = excluded.imageURL
                        row.thumbnailURL = excluded.thumbnailURL
                        row.isOffer = excluded.isOffer
                        row.isBestOffer = excluded.isBestOffer
                        row.additionalImages = excluded.additionalImages
                    }
                    .execute(db)
            }
        }
    }
}
