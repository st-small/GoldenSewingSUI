import Combine
import ModelsKit
import SwiftData
import SwiftUI

public protocol DataProviderProtocol {
    var categoriesPublisher: Published<[CategoryModel]>.Publisher { get }
    func addCategories(_ categories: [CategoryModel]) async
    func updateCategory(_ id: CategoryID, isFavourite: Bool) async
    func deleteCategory(_ id: CategoryID) async
    
    var postsPublisher: Published<[PostModel]>.Publisher { get }
    func addPosts(_ posts: [PostModel]) async
}

public final class DataProvider: ObservableObject, DataProviderProtocol {

    @Published private(set) var categories: [CategoryModel] = []
    public var categoriesPublisher: Published<[CategoryModel]>.Publisher { $categories }
    
    @Published private(set) var posts: [PostModel] = []
    public var postsPublisher: Published<[PostModel]>.Publisher { $posts }
    
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
    
    // MARK: - Categories
    public func addCategories(_ categories: [CategoryModel]) async {
        guard let context = modelContext else { preconditionFailure() }
        
        categories.forEach {
            context.insert(
                SDCategoryModel(
                    id: $0.id.value,
                    title: $0.title,
                    link: $0.link,
                    isFavourite: false
                )
            )
        }
        
        await save()
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
    
    // MARK: - Posts
    public func addPost(_ id: PostID, title: String) async {
        guard let context = modelContext else { preconditionFailure() }
        
        let post = SDPostModel(
            id: id.value,
            title: title
        )
        context.insert(post)
        
        await save()
        prefetchData()
    }
    
    public func addPosts(_ posts: [PostModel]) async {
        guard let context = modelContext else { preconditionFailure() }
        
        posts.forEach {
            context.insert(
                SDPostModel(
                    id: $0.id.value,
                    title: $0.title
                )
            )
        }
        
        await save()
        prefetchData()
    }
    
    // MARK: - Private
    
    private func prefetchData() {
        guard let context = modelContext else { preconditionFailure() }
        
        do {
            categories = try context.fetch(FetchDescriptor<SDCategoryModel>())
                .map { $0.map() }
            posts = try context.fetch(FetchDescriptor<SDPostModel>())
                .map { $0.map() }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    @MainActor
    private func save() async {
        guard let context = modelContext else { preconditionFailure() }
        
        do {
            try context.save()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

public final class DataProviderMock: DataProviderProtocol {
    @Published private(set) var categories: [CategoryModel] = []
    public var categoriesPublisher: Published<[CategoryModel]>.Publisher { $categories }
    
    @Published private(set) var posts: [PostModel] = []
    public var postsPublisher: Published<[PostModel]>.Publisher { $posts }
    
    public init() { }
    
    public func addCategories(_ categories: [CategoryModel]) {
        self.categories = categories
    }
    
    public func updateCategory(_ id: ModelsKit.CategoryID, isFavourite: Bool) { }
    public func deleteCategory(_ id: ModelsKit.CategoryID) { }
    
    public func addPost(_ id: PostID, title: String) {
        posts.append(PostModel(id: id.value, title: title))
    }
    
    public func addPosts(_ posts: [PostModel]) { }
}
