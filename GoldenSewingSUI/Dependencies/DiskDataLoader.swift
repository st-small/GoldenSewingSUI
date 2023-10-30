import Dependencies
import Foundation

struct DiskDataLoader: Sendable {
    var loadCategories: @Sendable () throws -> [CategoryDTO]
    var loadPosts: @Sendable () throws -> [PostDTO]
}

extension DiskDataLoader: DependencyKey {
    static let liveValue = Self(
        loadCategories: {
            let data = try Data(contentsOf: URL.categories)
            return try JSONDecoder().decode([CategoryDTO].self, from: data)
        },
        loadPosts: {
            let data = try Data(contentsOf: URL.posts)
            return try JSONDecoder().decode([PostDTO].self, from: data)
        }
    )
    
    static let testValue = Self(
        loadCategories: { [CategoryDTO.mock] },
        loadPosts: { [PostDTO.mock] }
    )
    
    static let failToLoad = Self(
        loadCategories: {
            struct LoadCategoriesError: Error, LocalizedError {
                var errorDescription: String? { "Load categories error" }
            }
            throw LoadCategoriesError()
        },
        loadPosts: {
            struct LoadPostsError: Error, LocalizedError {
                var errorDescription: String? { "Load posts error" }
            }
            throw LoadPostsError()
        }
    )
}

extension DependencyValues {
    var diskDataLoader: DiskDataLoader {
        get { self[DiskDataLoader.self] }
        set { self[DiskDataLoader.self] = newValue }
    }
}
