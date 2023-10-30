import ComposableArchitecture
import XCTest

@testable import GoldenSewingSUI

@MainActor
final class PostsDataProviderTests: XCTestCase {

    // Load cached disk when DB is empty with success result
    func test_empty_database_success() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .testValue
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadPostsDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.postsLoaded([.mock]))
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load cached disk when DB is empty with failure result
    func test_empty_database_failure() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .failToLoad
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadPostsDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.error("Load posts error"))
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load database data when it is not empty
    func test_database_is_not_empty_success() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .mock
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.postsLoaded([.mock]))
        await store.receive(.fetchAPIData)
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load database data when it is not empty failed
    func test_database_is_not_empty_failed() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .fail
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.error("CoreData load Posts error"))
        await store.receive(.fetchAPIData)
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load database calls API and get success response
    func test_call_API_and_get_data() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadPostsDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.postsLoaded([.mock]))
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load data getting error
    func test_call_API_and_get_error() async throws {
        let store = TestStore(initialState: PostsProvider.State()) {
            PostsProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.apiClient = .errorValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadPostsDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.postsLoaded([.mock]))
        await store.receive(.error("Posts API error"))
    }
}
