import ComposableArchitecture
import XCTest

@testable import GoldenSewingSUI

@MainActor
final class CategoriesDataProviderTests: XCTestCase {
    
    // Load cached disk when DB is empty
    func test_empty_database() async throws {
        let store = TestStore(initialState: CategoriesProvider.State()) {
            CategoriesProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .testValue
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadCategoriesDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.categoriesLoaded([.mock]))
        await store.receive(.categoriesLoaded([.mock]))
    }
    
    // Load database data when it is not empty
    func test_database_is_not_empty() async throws {
        let store = TestStore(initialState: CategoriesProvider.State()) {
            CategoriesProvider()
        } withDependencies: {
            $0.coreData = .mock
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.categoriesLoaded([.mock]))
        await store.receive(.fetchAPIData)
        await store.receive(.categoriesLoaded([.mock]))
    }
    
    // Load data base calls API and get success response
    func test_call_API_and_get_data() async throws {
        let store = TestStore(initialState: CategoriesProvider.State()) {
            CategoriesProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.apiClient = .testValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadCategoriesDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.categoriesLoaded([.mock]))
        await store.receive(.categoriesLoaded([.mock]))
    }
    
    // Load data getting error
    func test_call_API_and_get_error() async throws {
        let store = TestStore(initialState: CategoriesProvider.State()) {
            CategoriesProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.apiClient = .errorValue
        }
        
        await store.send(.loadDBData)
        await store.receive(.loadCategoriesDiskData)
        await store.receive(.fetchAPIData)
        await store.receive(.categoriesLoaded([.mock]))
        await store.receive(.error("Categories API error"))
    }
}
