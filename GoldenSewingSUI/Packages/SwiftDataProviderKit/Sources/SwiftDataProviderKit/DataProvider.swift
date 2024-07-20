import Combine
import ModelsKit
import SwiftData
import SwiftUI

public protocol DataProviderProtocol {
    var categoriesPublisher: Published<[CategoryModel]>.Publisher { get }
    func addCategory(_ id: CategoryID, title: String, link: String)
    func updateCategory(_ id: CategoryID, isFavourite: Bool)
    func deleteCategory(_ id: CategoryID)
}

public final class DataProvider: ObservableObject, DataProviderProtocol {

    @Published private(set) var categories: [CategoryModel] = []
    public var categoriesPublisher: Published<[CategoryModel]>.Publisher { $categories }
    
    private(set) var modelContext: ModelContext? = nil
    private(set) var modelContainer: ModelContainer? = nil
    
    @MainActor
    public init(inMemory: Bool = false) {
        let schema = Schema(CurrentScheme.models)
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            modelContext = modelContainer?.mainContext
            modelContext?.autosaveEnabled = true
        } catch {
            preconditionFailure("Could not create ModelContainer: \(error)")
        }
        
        prefetchData()
    }
    
    // MARK: - Public
    
    public func addCategory(_ id: CategoryID, title: String, link: String) {
        guard let context = modelContext else { preconditionFailure() }
        
        let category = SDCategoryModel(
            id: id.value,
            title: title,
            link: link,
            isFavourite: false
        )
        context.insert(category)
        
        do {
            try context.save()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
        
        prefetchData()
    }
    
    public func updateCategory(_ id: CategoryID, isFavourite: Bool) {
        guard let context = modelContext else { preconditionFailure() }
        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
        
        do {
            let category = try context.fetch(fetchDescriptor).first
            category?.isFavorite = isFavourite
            
            try context.save()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    public func deleteCategory(_ id: CategoryID) {
//        guard let context = modelContext else { preconditionFailure() }
//        let fetchDescriptor = FetchDescriptor<SDCategoryModel>()
//
//        do {
//            let category = try context.fetch(fetchDescriptor).first
//            context.delete(category)
//            try context.save()
//        } catch {
//            preconditionFailure(error.localizedDescription)
//        }
//        
//        prefetchData()
    }
    
    // MARK: - Private
    
    private func prefetchData() {
        guard let context = modelContext else { preconditionFailure() }
        
        do {
            categories = try context.fetch(FetchDescriptor<SDCategoryModel>())
                .map { $0.map() }
            categories.forEach { print($0.id) }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

public final class DataProviderMock: DataProviderProtocol {
    @Published private(set) var categories: [CategoryModel] = []
    public var categoriesPublisher: Published<[CategoryModel]>.Publisher { $categories }
    
    public init() { }
    
    public func addCategory(_ id: CategoryID, title: String, link: String) {
        categories.append(
            CategoryModel(
                id: id.value,
                title: title,
                link: link
            )
        )
    }
    
    public func updateCategory(_ id: ModelsKit.CategoryID, isFavourite: Bool) { }
    public func deleteCategory(_ id: ModelsKit.CategoryID) { }
}
