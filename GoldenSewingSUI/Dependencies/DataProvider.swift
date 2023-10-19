import ComposableArchitecture
import Foundation

struct DataProvider: Reducer {
    struct State: Equatable {
        var current: ProviderState?
    }
    
    enum ProviderState: Equatable {
        case loadingCategoriesFromDisk
        case loadingPostsFromDisk
        case loadingFromDB
        case loadingCategoriesAPI
        case loadingPostsAPI
        case complete
        case error(String)
    }
    
    enum Action: Equatable {
        case loadCategoriesDiskData
        case loadPostsDiskData
        case loadDBData
        case fetchCategoriesAPIData
        case fetchPostsAPIData
        case categoriesLoaded([CategoryDTO])
        case postsLoaded([PostDTO])
        case error(String)
    }
    
    @Dependency(\.coreData) var database
    @Dependency(\.diskDataLoader.load) var cached
    @Dependency(\.apiClient) var api
    @Dependency(\.logger) var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadCategoriesDiskData:
                state.current = .loadingCategoriesFromDisk
                return .run { send in
                    do {
                        let categories = try JSONDecoder().decode([CategoryDTO].self, from: cached(.categories))
                        await send(.categoriesLoaded(categories))
                        logger.info("--- Cached categories disk data loading complete ---")
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 Cached categories disk data error \(error.localizedDescription)")
                    }
                }.merge(with: .run(operation: { send in
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    await send(.fetchCategoriesAPIData)
                }))
                
            case .loadPostsDiskData:
                state.current = .loadingPostsFromDisk
                return .run { send in
                    do {
                        let posts = try JSONDecoder().decode([PostDTO].self, from: cached(.posts))
                        await send(.postsLoaded(posts))
                        logger.info("--- Cached posts disk data loading complete ---")
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 Cached posts disk data error \(error.localizedDescription)")
                    }
                }.merge(with: .run(operation: { send in
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    await send(.fetchPostsAPIData)
                }))
                
            case .loadDBData:
                state.current = .loadingFromDB
                return .run { send in
                    let categories = try? await database.loadCategories()
                    if let categories, !categories.isEmpty {
                        await send(.categoriesLoaded(categories))
                        #warning("Add logic to update DB from API if last update was so far")
                        logger.info("--- Core data categories loading complete ---")
                    } else {
                        await send(.loadCategoriesDiskData)
                    }
                    
                    let posts = try? await database.loadPosts(nil)
                    if let posts, !posts.isEmpty {
                        await send(.postsLoaded(posts))
                        #warning("Add logic to update DB from API if last update was so far")
                        logger.info("--- Core data posts loading complete ---")
                    } else {
                        await send(.loadPostsDiskData)
                    }
                }
                .merge(with: .run(operation: { send in
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    await send(.fetchCategoriesAPIData)
                }))
                .merge(with: .run(operation: { send in
                    try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                    await send(.fetchPostsAPIData)
                }))
            
            case .fetchCategoriesAPIData:
                state.current = .loadingCategoriesAPI
                return .run { send in
                    do {
                        let categories = try await api.fetchCategories()
                        await send(.categoriesLoaded(categories))
                        logger.info("--- Categories API data fetching complete ---")
                        
                        for category in categories {
                            try await database.saveCategory(category)
                        }
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 API request error \(error.localizedDescription)")
                    }
                }
                
            case .fetchPostsAPIData:
                state.current = .loadingPostsAPI
                return .run { send in
                    do {
                        let posts = try await api.fetchPosts()
                        await send(.postsLoaded(posts))
                        logger.info("--- Posts API data fetching complete ---")
                        
                        for post in posts {
                            try await database.savePost(post)
                        }
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 API request error \(error.localizedDescription)")
                    }
                }

            case .categoriesLoaded:
                state.current = .complete
                logger.info("--- Categories data loading complete successfully ---")
                return .none
            case .postsLoaded:
                state.current = .complete
                logger.info("--- Posts data loading complete successfully ---")
                return .none
            case let .error(error):
                state.current = .error(error)
                logger.error("🔴 Data loading error \(error)")
                return .none
            }
        }
    }
}
