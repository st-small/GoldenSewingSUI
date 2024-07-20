import XCTest
import CachedDataKit
@testable import DataNormaliserKit
import ModelsKit
import SwiftDataProviderKit

final class DataNormaliserKitTests: XCTestCase {
    func test_empty_database() async {
        let swiftData = DataProviderMock()
        let cache = DataSourceMock()
        
        let normaliser = await DataNormaliser(
            cache: cache,
            swiftData: swiftData
        )
        
        let cachedCategories = [
            CategoryModel(id: 1),
            CategoryModel(id: 3),
            CategoryModel(id: 5),
        ]
        
        XCTAssertEqual(swiftData.categories, [])
        
        await normaliser.start()
        
        XCTAssertEqual(swiftData.categories, cachedCategories)
    }
}
