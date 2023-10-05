import Dependencies
import Foundation

struct DiskDataLoader: Sendable {
    var load: @Sendable (URL) throws -> Data
}

extension DiskDataLoader: DependencyKey {
    static let liveValue = Self(
        load: { url in try Data(contentsOf: url) }
    )
    
    static let testValue = Self(
        load: { url in
            switch url {
            case URL.categories:
                return try JSONEncoder().encode([CategoryDTO.mock])
            case URL.posts:
                return try JSONEncoder().encode([PostDTO.mock])
            default:
                return .init()
            }
        }
    )
}

extension DependencyValues {
    var diskDataLoader: DiskDataLoader {
        get { self[DiskDataLoader.self] }
        set { self[DiskDataLoader.self] = newValue }
    }
}

extension DiskDataLoader {
    static func mock(initialData: Data? = nil) -> Self {
        let data = LockIsolated(initialData)
        return Self(
            load: { _ in
                guard let data = data.value
                else {
                    struct FileNotFound: Error {}
                    throw FileNotFound()
                }
                return data
            }
        )
    }
    
    static let failToLoad = Self(
        load: { _ in
            struct LoadError: Error, LocalizedError {
                var errorDescription: String? { "Load error" }
            }
            throw LoadError()
        }
    )
}
