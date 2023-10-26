import Dependencies
import Foundation

struct DiskDataLoader: Sendable {
    var loadCategories: @Sendable () throws -> [CategoryDTO]
}

extension DiskDataLoader: DependencyKey {
    static let liveValue = Self(
        loadCategories: {
            let data = try Data(contentsOf: URL.categories)
            return try JSONDecoder().decode([CategoryDTO].self, from: data)
        }
    )
    
    static let testValue = Self(
        loadCategories: { [CategoryDTO.mock] }
    )
    
    static let failToLoad = Self(
        loadCategories: {
            struct LoadError: Error, LocalizedError {
                var errorDescription: String? { "Load error" }
            }
            throw LoadError()
        }
    )
}

extension DependencyValues {
    var diskDataLoader: DiskDataLoader {
        get { self[DiskDataLoader.self] }
        set { self[DiskDataLoader.self] = newValue }
    }
}
