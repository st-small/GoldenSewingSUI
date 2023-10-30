import CoreData
import Dependencies

final class ContextContainer {
    
    static let shared = ContextContainer()
    
    static private var persistentContainer: NSPersistentContainer {
        let persistentContainer = NSPersistentContainer(name: "GS")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            preconditionFailure(error.localizedDescription)
        }
        
        return persistentContainer
    }
    
    var context: NSManagedObjectContext {
        Self.persistentContainer.viewContext
    }
}

struct CoreData: Sendable {
    
    static private let context = ContextContainer.shared.context
    
    var loadPosts: @Sendable (NSPredicate?) throws -> [PostDTO]
    var savePost: @Sendable (PostDTO) async throws -> Void
    var dropPosts: @Sendable () async throws -> Void
    
    var loadCategories: @Sendable () throws -> [CategoryDTO]
    var saveCategory: @Sendable (CategoryDTO) async throws -> Void
    var dropCategories: @Sendable () async throws -> Void
    
    var postsParentIDPredicate: @Sendable (CategoryDTO.ID) -> NSPredicate
}

extension CoreData: DependencyKey {
    static let liveValue = Self(
        loadPosts: { predicate in
            let request = Post.fetchRequest()
            request.predicate = predicate
            let posts = try ContextContainer.shared.context.fetch(request)
            
            return posts.map { .init(from: $0) }
        },
        savePost: { post in
            let context = ContextContainer.shared.context
            guard let newPost = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as? Post else { return }
            newPost.id = post.id
            newPost.title = post.title
            newPost.category = post.categories.first ?? -1
            
            try context.save()
        },
        dropPosts: { try dropEntities(with: "Post") },
        loadCategories: {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            let categories = (try ContextContainer.shared.context.fetch(request) as? [Category]) ?? []
            
            return categories.map { .init(from: $0) }
        },
        saveCategory: { category in
            let request = Category.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", category.id)
            let storedCategories = (try? context.fetch(request)) ?? []
            
            if let first = storedCategories.first {
                first.title = category.title
            } else {
                let newCategory = Category(context: context)
                newCategory.id = category.id
                newCategory.title = category.title
            }
            
            context.perform {
                do {
                    try context.save()
                } catch {
                    @Dependency(\.logger) var logger
                    logger.error("error.localizedDescription")
                }
            }
        },
        dropCategories: { try dropEntities(with: "Category") },
        postsParentIDPredicate: { NSPredicate(format: "category = %d", $0) }
    )
    
    static private func dropEntities(with name: String) throws {
        let context = ContextContainer.shared.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let result = try context.fetch(request)
        for entity in result {
            guard let entity = entity as? NSManagedObject else { continue }
            context.delete(entity)
        }
        try context.save()
    }
    
    static let testValue = Self(
        loadPosts: { _ in [] },
        savePost: { _ in },
        dropPosts: { },
        loadCategories: { [] },
        saveCategory: { _ in },
        dropCategories: { },
        postsParentIDPredicate: { _ in NSPredicate() }
    )
    
    static let mock = Self(
        loadPosts: { _ in [PostDTO.mock] },
        savePost: { _ in },
        dropPosts: { },
        loadCategories: { [CategoryDTO.mock] },
        saveCategory: { _ in },
        dropCategories: { },
        postsParentIDPredicate: { _ in NSPredicate() }
    )
}

extension DependencyValues {
    var coreData: CoreData {
        get { self[CoreData.self] }
        set { self[CoreData.self] = newValue }
    }
}
