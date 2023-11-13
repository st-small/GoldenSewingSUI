import CoreData
import Dependencies

final class ContextContainer {
    
    static let shared = ContextContainer()
    
    static private var persistentContainer: NSPersistentContainer {
        Int32ArrayValueTransformer.register()
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
    
    var loadPosts: @Sendable () throws -> [PostDTO]
    var savePost: @Sendable (PostDTO) async throws -> Void
    var updatePost: @Sendable (PostDTO.ID, Bool) async throws -> Void
    var dropPosts: @Sendable () async throws -> Void
    
    var loadCategories: @Sendable () throws -> [CategoryDTO]
    var saveCategory: @Sendable (CategoryDTO) async throws -> Void
    var dropCategories: @Sendable () async throws -> Void
    
    var loadMedia: @Sendable (Int32) throws -> MediaDTO?
    var saveMedia: @Sendable (MediaDTO) async throws -> Void
}

extension CoreData: DependencyKey {
    static let liveValue = Self(
        loadPosts: {
            let request = Post.fetchRequest()
            let posts = try ContextContainer.shared.context.fetch(request)
            
            return posts.map { .init(from: $0) }
        },
        savePost: { post in
            let request = Post.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", post.id)
            
            await MainActor.run {
                let storedPosts = (try? context.fetch(request)) ?? []
                
                if let first = storedPosts.first {
                    first.date = post.date
                    first.modified = post.modified
                    first.link = post.link
                    first.title = post.title
                    first.mainImage = post.mainImage
                    first.categories = post.categories
                    first.gallery = post.gallery
                } else {
                    let newPost = Post(context: context)
                    newPost.id = post.id
                    newPost.date = post.date
                    newPost.modified = post.modified
                    newPost.link = post.link
                    newPost.title = post.title
                    newPost.mainImage = post.mainImage
                    newPost.categories = post.categories
                    newPost.gallery = post.gallery
                }
                
                context.perform {
                    do {
                        try context.save()
                    } catch {
                        @Dependency(\.logger) var logger
                        logger.error("\(error.localizedDescription)")
                    }
                }
            }
        },
        updatePost: { id, isFavourite in
            let request = Post.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", id)
            let posts = try context.fetch(request)
            
            guard let post = posts.first else { return }
            post.isFavourite = isFavourite
            
            context.perform {
                do {
                    try context.save()
                } catch {
                    @Dependency(\.logger) var logger
                    logger.error("\(error.localizedDescription)")
                }
            }
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
            
            await MainActor.run {
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
                        logger.error("\(error.localizedDescription)")
                    }
                }
            }
        },
        dropCategories: { try dropEntities(with: "Category") },
        loadMedia: { mediaID in
            let request = Media.fetchRequest()
            let predicate = NSPredicate(format: "id = %d", mediaID)
            request.predicate = predicate
            let mediaResult = try context.fetch(request)
            
            guard mediaResult.isNotEmpty, let first = mediaResult.first else {
                @Dependency(\.logger) var logger
                logger.error("🔴 Media request with predicate \(mediaID) is empty")
                return nil
            }
            
            return MediaDTO(id: first.id, sourceUrl: first.sourceUrl)
        },
        saveMedia: { media in
            let request = Media.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d", media.id)
            
            await MainActor.run {
                let storedMedia = (try? context.fetch(request)) ?? []
                if storedMedia.isEmpty {
                    let newMedia = Media(context: context)
                    newMedia.id = media.id
                    newMedia.sourceUrl = media.sourceUrl
                }
                
                context.perform {
                    do {
                        try context.save()
                    } catch {
                        @Dependency(\.logger) var logger
                        logger.error("\(error.localizedDescription)")
                    }
                }
            }
        }
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
        loadPosts: { [] },
        savePost: { _ in },
        updatePost: { _,_ in },
        dropPosts: { },
        loadCategories: { [] },
        saveCategory: { _ in },
        dropCategories: { },
        loadMedia: { _ in .mock },
        saveMedia: { _ in }
    )
    
    static let mock = Self(
        loadPosts: { [PostDTO.mock] },
        savePost: { _ in },
        updatePost: { _,_ in },
        dropPosts: { },
        loadCategories: { [CategoryDTO.mock] },
        saveCategory: { _ in },
        dropCategories: { },
        loadMedia: { _ in .mock },
        saveMedia: { _ in }
    )
    
    static let fail = Self(
        loadPosts: {
            struct CoreDataError: Error, LocalizedError {
                var errorDescription: String? { "CoreData load Posts error" }
            }
            throw CoreDataError()
        },
        savePost: { _ in },
        updatePost: { _,_ in },
        dropPosts: { },
        loadCategories: { [CategoryDTO.mock] },
        saveCategory: { _ in },
        dropCategories: { },
        loadMedia: { _ in .mock },
        saveMedia: { _ in }
    )
}

extension DependencyValues {
    var coreData: CoreData {
        get { self[CoreData.self] }
        set { self[CoreData.self] = newValue }
    }
}
