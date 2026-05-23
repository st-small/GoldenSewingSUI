@testable import CatalogCore
import Dependencies
import Testing

@Suite struct SearchServiceTests {
    private func syncedDB() async throws -> any DatabaseWriter {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
        }
        return db
    }

    @Test func categoriesSortedByPriorityDescending() async throws {
        let db = try await syncedDB()
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let results = try await search.categories("")
            guard results.count > 1 else { return }
            for i in 0 ..< results.count - 1 {
                #expect(results[i].priority >= results[i + 1].priority)
            }
        }
    }

    @Test func emptyQueryReturnsAllCategories() async throws {
        let db = try await syncedDB()
        let allCount = try await db.read { try Category.fetchAll($0).count }
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let results = try await search.categories("")
            #expect(results.count == allCount)
        }
    }

    @Test func searchCategoriesByName() async throws {
        let db = try await syncedDB()
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let results = try await search.categories("митр")
            #expect(!results.isEmpty)
            for cat in results {
                #expect(
                    cat.name.localizedCaseInsensitiveContains("митр") ||
                        cat.slug.localizedCaseInsensitiveContains("митр")
                )
            }
        }
    }

    @Test func searchProductsByName() async throws {
        let db = try await syncedDB()
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let results = try await search.products("икон", nil)
            #expect(!results.isEmpty)
        }
    }

    @Test func filterProductsByCategory() async throws {
        let db = try await syncedDB()
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let categoryId: Int32 = 4 // Иконы
            let results = try await search.products("", categoryId)
            #expect(!results.isEmpty)
            for product in results {
                #expect(product.categoryId == categoryId)
            }
        }
    }

    @Test func bestOfferProductsAppearFirst() async throws {
        let db = try await syncedDB()
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSearchService) var search
            let results = try await search.products("", nil)
            guard let firstNonBestOffer = results.firstIndex(where: { !$0.isBestOffer }) else { return }
            let before = results.prefix(firstNonBestOffer)
            let allSatisfy = before.allSatisfy(\.isBestOffer)
            #expect(allSatisfy)
        }
    }
}
