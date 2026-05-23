@testable import CatalogCore
import Dependencies
import Testing

@Suite struct SyncServiceTests {
    @Test func syncLoadsCategoriesFromJSON() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            let cats = try await db.read { try Category.fetchAll($0) }
            #expect(!cats.isEmpty)
        }
    }

    @Test func syncLoadsExpectedCategoryIDs() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            let cats = try await db.read { try Category.fetchAll($0) }
            let ids = Set(cats.map(\.id))
            // Ключевые категории из categories.json должны присутствовать
            #expect(ids.contains(6)) // Митры
            #expect(ids.contains(4)) // Иконы
            #expect(ids.contains(7)) // Архиерейские облачения
        }
    }

    @Test func syncCategoryPrioritiesAreSet() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            let cats = try await db.read { try Category.fetchAll($0) }
            let ikonyCat = cats.first { $0.id == 4 }
            #expect(ikonyCat?.priority == 160)
        }
    }

    @Test func syncIsIdempotent() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            try await sync.sync()
            let cats = try await db.read { try Category.fetchAll($0) }
            let uniqueIds = Set(cats.map(\.id))
            #expect(cats.count == uniqueIds.count)
        }
    }

    @Test func syncLoadsProductsFromJSON() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            let products = try await db.read { try Product.fetchAll($0) }
            #expect(!products.isEmpty)
        }
    }

    @Test func productHasImageURL() async throws {
        let db = try makeAppDatabase(inMemory: true)
        try await withDependencies {
            $0.defaultDatabase = db
        } operation: {
            @Dependency(\.catalogSyncService) var sync
            try await sync.sync()
            let products = try await db.read { try Product.fetchAll($0) }
            let withImages = products.filter { !$0.imageURL.isEmpty }
            #expect(!withImages.isEmpty)
        }
    }
}
