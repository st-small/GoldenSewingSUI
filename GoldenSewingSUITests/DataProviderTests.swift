import ComposableArchitecture
import XCTest

@testable import GoldenSewingSUI

@MainActor
final class DataProviderTests: XCTestCase {
    // Core data and disk cache are empty
    // Loading from the API
    func test_empty_core_data_empty_disk_cache() async throws {
        let store = TestStore(initialState: DataProvider.State()) {
            DataProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .failToLoad
        }
        
        await store.send(.loadDBData) {
            $0.current = .loadingFromDB
        }
        
        await store.receive(.loadCategoriesDiskData) {
            $0.current = .loadingCategoriesFromDisk
        }
        
        await store.receive(.loadPostsDiskData) {
            $0.current = .loadingPostsFromDisk
        }
        
        await store.receive(.error("Load error")) {
            $0.current = .error("Load error")
        }
        
        await store.receive(.error("Load error"))
        
        await store.receive(.fetchCategoriesAPIData) {
            $0.current = .loadingCategoriesAPI
        }
        
        await store.receive(.fetchPostsAPIData) {
            $0.current = .loadingPostsAPI
        }
        
        await store.receive(.categoriesLoaded([.mock])) {
            $0.current = .complete
        }
        
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Core data is empty, disk cache is not empty,
    // Loading from the API
    func test_empty_core_data_not_empty_disk_cache() async throws {
        let store = TestStore(initialState: DataProvider.State()) {
            DataProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .testValue
        }
        
        await store.send(.loadDBData) {
            $0.current = .loadingFromDB
        }
        
        await store.receive(.loadCategoriesDiskData) {
            $0.current = .loadingCategoriesFromDisk
        }
        
        await store.receive(.loadPostsDiskData) {
            $0.current = .loadingPostsFromDisk
        }
        
        await store.receive(.categoriesLoaded([.mock])) {
            $0.current = .complete
        }
        
        await store.receive(.postsLoaded([.mock]))
        
        await store.receive(.fetchCategoriesAPIData) {
            $0.current = .loadingCategoriesAPI
        }
        
        await store.receive(.fetchPostsAPIData) {
            $0.current = .loadingPostsAPI
        }
        
        await store.receive(.categoriesLoaded([.mock])) {
            $0.current = .complete
        }
        
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Core data is not empty
    func test_core_data_is_not_empty() async throws {
        let store = TestStore(initialState: DataProvider.State()) {
            DataProvider()
        } withDependencies: {
            $0.coreData = .mock
            $0.diskDataLoader = .testValue
        }
        
        await store.send(.loadDBData) {
            $0.current = .loadingFromDB
        }
        
        await store.receive(.categoriesLoaded([.mock])) {
            $0.current = .complete
        }
        
        await store.receive(.postsLoaded([.mock]))
    }
    
    // Load from internet error
    func test_load_api_with_error() async throws {
        let store = TestStore(initialState: DataProvider.State()) {
            DataProvider()
        } withDependencies: {
            $0.coreData = .testValue
            $0.diskDataLoader = .testValue
            $0.apiClient = .errorValue
        }
        
        await store.send(.loadDBData) {
            $0.current = .loadingFromDB
        }
        
        await store.receive(.loadCategoriesDiskData) {
            $0.current = .loadingCategoriesFromDisk
        }
        
        await store.receive(.loadPostsDiskData) {
            $0.current = .loadingPostsFromDisk
        }
        
        await store.receive(.categoriesLoaded([.mock])) {
            $0.current = .complete
        }
        
        await store.receive(.postsLoaded([.mock]))
        
        await store.receive(.fetchCategoriesAPIData) {
            $0.current = .loadingCategoriesAPI
        }
        
        await store.receive(.fetchPostsAPIData) {
            $0.current = .loadingPostsAPI
        }
        
        await store.receive(.error("Categories API error")) {
            $0.current = .error("Categories API error")
        }
        
        await store.receive(.error("Posts API error")) {
            $0.current = .error("Posts API error")
        }
    }
    
    // *** Core data is not empty but load from API if ...
    #warning("Update tests ASAP")
}
