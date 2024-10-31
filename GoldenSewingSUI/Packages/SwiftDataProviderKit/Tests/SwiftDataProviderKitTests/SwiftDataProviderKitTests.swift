@testable
import ModelsKit
import SwiftDataProviderKit
import SwiftData
import XCTest

final class SwiftDataProviderKitTests: XCTestCase {
    
    @MainActor
    func testAddCategory() async throws {
        let container = try ContainerForTest.temp(#function)
        let handler = DataHandler(container: container)
        
        let category = CategoryModel(
            id: UInt32(111),
            title: "Cookies",
            link: "",
            isFavourite: false
        )
        await handler.addCategories([category])
        
        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
        let categories = try container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertNotNil(categories.first, "The category should be created and fetched successfully.")
        XCTAssertEqual(categories.count, 1, "There should be exactly one category in the store.")
        
        if let firstCategory = categories.first {
            XCTAssertEqual(firstCategory.title, category.title, "The category's title should match the initially provided one.")
        } else {
            XCTFail("Expected to find a category but none was found.")
        }
    }
    
    @MainActor
    func testUpdateCategory() async throws {
        let container = try ContainerForTest.temp(#function)
        let handler = DataHandler(container: container)
        
        let category = CategoryModel(
            id: UInt32(111),
            title: "Cookies",
            link: "",
            isFavourite: false
        )
        await handler.addCategories([category])
        
        let updatedCategory = CategoryModel(
            id: UInt32(111),
            title: "Cookies 2",
            link: "",
            isFavourite: false
        )
        await handler.addCategories([updatedCategory])
        
        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
        let categories = try container.mainContext.fetch(fetchDescriptor)
        
        XCTAssertNotNil(categories.first, "The category should be created and fetched successfully.")
        XCTAssertEqual(categories.count, 1, "There should be exactly one category in the store.")
        
        if let firstCategory = categories.first {
            XCTAssertEqual(firstCategory.title, updatedCategory.title, "The category's title should match the initially provided one.")
        } else {
            XCTFail("Expected to find a category but none was found.")
        }
    }
    
    // TODO: Тестирование обновления категории с продуктами
    
    // TODO: Тестирование продуктов
}
