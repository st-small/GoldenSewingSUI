import ModelsKit
import XCTest
@testable import CachedDataKit

final class CachedDataKitTests: XCTestCase {
    
    func test_load_categories_success() {
        let dataLoading: DataLoadingFunction = { _, handler in
            handler(.success(Data()))
        }
        
        DataSource().loadCategories(dataLoading: dataLoading) { result in
            guard case let .success(categories) = result else { return }
            XCTAssertNotNil(categories)
        }
    }
    
    func test_load_categories_failure() {
        let dataLoading: DataLoadingFunction = { _, handler in
            handler(.failure(.categoriesDataFileMissing))
        }
        
        DataSource().loadCategories(dataLoading: dataLoading) { result in
            guard case let .failure(error) = result else { return }
            XCTAssertEqual(error, CachedDataKitError.categoriesDataFileMissing)
        }
    }
    
    func test_load_posts_success() {
        let dataLoading: DataLoadingFunction = { _, handler in
            handler(.success(Data()))
        }
        
        DataSource().loadPosts(dataLoading: dataLoading) { result in
            guard case let .success(posts) = result else { return }
            XCTAssertNotNil(posts)
        }
    }
    
    func test_load_posts_failure() {
        let dataLoading: DataLoadingFunction = { _, handler in
            handler(.failure(.postsDataFileMissing))
        }
        
        DataSource().loadPosts(dataLoading: dataLoading) { result in
            guard case let .failure(error) = result else { return }
            XCTAssertEqual(error, CachedDataKitError.postsDataFileMissing)
        }
    }
}
