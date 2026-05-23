import Dependencies
import GRDB
import SQLiteData

private enum DefaultDatabaseKey: DependencyKey {
    static let liveValue: any DatabaseWriter = try! makeAppDatabase()
    static let testValue: any DatabaseWriter = try! makeAppDatabase(inMemory: true)
}

public extension DependencyValues {
    var defaultDatabase: any DatabaseWriter {
        get { self[DefaultDatabaseKey.self] }
        set { self[DefaultDatabaseKey.self] = newValue }
    }
}

public extension DependencyValues {
    var catalogSyncService: CatalogSyncService {
        get { self[CatalogSyncService.self] }
        set { self[CatalogSyncService.self] = newValue }
    }

    var catalogSearchService: CatalogSearchService {
        get { self[CatalogSearchService.self] }
        set { self[CatalogSearchService.self] = newValue }
    }
}
