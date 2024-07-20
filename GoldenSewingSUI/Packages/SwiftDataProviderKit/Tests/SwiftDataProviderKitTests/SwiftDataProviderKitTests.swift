@testable 
import SwiftDataProviderKit
import SwiftData
import XCTest

final class SwiftDataProviderKitTests: XCTestCase {
    
    @MainActor
    func testAddCategory() async throws {
        let provider = DataProvider(inMemory: true)
        
        let id = Int32(111)
        let title = "Cookies"
        provider.addCategory(id, title: title)
        
        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
        let categories = try provider.modelContainer?.mainContext.fetch(fetchDescriptor)
        
        XCTAssertNotNil(categories!.first, "The category should be created and fetched successfully.")
        XCTAssertEqual(categories!.count, 1, "There should be exactly one category in the store.")
        
        if let firstCategory = categories?.first {
            XCTAssertEqual(firstCategory.title, title, "The category's title should match the initially provided one.")
        } else {
            XCTFail("Expected to find a category but none was found.")
        }
    }
    
    // TODO: ...
    
//    @MainActor
//    func testUpdateCategory() async throws {
//        let container = try ContainerForTest.temp(#function)
//        let handler = DataHandler(modelContainer: container)
//        
//        let id = Int32(111)
//        let title = "Cookies"
//        let categoryID = try await handler.addCategory(id: id, title: title)
//        
//        let newTitle = "Fruits"
//        try await handler.updateCategory(id: categoryID, title: newTitle)
//        
//        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
//        let categories = try container.mainContext.fetch(fetchDescriptor)
//        
//        XCTAssertNotNil(categories.first, "The category should be created and fetched successfully.")
//        XCTAssertEqual(categories.count, 1, "There should be exactly one category in the store.")
//        
//        if let firstCategory = categories.first {
//            XCTAssertEqual(firstCategory.title, newTitle, "The category's title should match the new one.")
//        } else {
//            XCTFail("Expected to find a category but none was found.")
//        }
//    }
    
//    @MainActor
//    func testDeleteCategory() async throws {
//        let container = try ContainerForTest.temp(#function)
//        let handler = DataHandler(modelContainer: container)
//        
//        let id = Int32(111)
//        let title = "Cookies"
//        let categoryID = try await handler.addCategory(id: id, title: title)
//        
//        try await handler.deleteCategory(id: categoryID)
//        
//        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
//        let categoriesCount = try container.mainContext.fetchCount(fetchDescriptor)
//        
//        XCTAssertEqual(categoriesCount, 0)
//    }
}
