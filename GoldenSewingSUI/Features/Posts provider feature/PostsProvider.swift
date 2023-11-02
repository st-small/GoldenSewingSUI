import ComposableArchitecture

struct PostsProvider: Reducer {
    struct State: Equatable { }
    
    enum Action: Equatable {
        case loadPostsDiskData
        case loadDBData
        case fetchAPIData
        case postsLoaded([PostDTO])
        case error(String)
    }
    
    @Dependency(\.coreData) var dataBase
    @Dependency(\.diskDataLoader.loadPosts) var cached
    @Dependency(\.apiClient) var api
    @Dependency(\.logger) var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadPostsDiskData:
                logger.info("--- Try to load posts from cached data ---")
                return .run { send in
                    do {
                        await send(.postsLoaded(try cached()))
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 Cached posts disk data error: \(error.localizedDescription)")
                    }
                }
            case .loadDBData:
                logger.info("--- Try to fetch posts from DB ---")
                return .run { send in
                    do {
                        let posts = try dataBase.loadPosts()
                        if posts.isEmpty {
                            await send(.loadPostsDiskData)
                        } else {
                            await send(.postsLoaded(posts))
                        }
                    } catch {
                        logger.error("🔴 Load posts DB data error: \(error.localizedDescription)")
                        await send(.error(error.localizedDescription))
                    }
                }
                .merge(with: .run(operation: { send in
                    await send(.fetchAPIData)
                }))
            case .fetchAPIData:
                logger.info("--- Try to fetch posts from API ---")
                return .run { send in
                    do {
                        let posts = try await api.fetchPosts()
                        logger.info("--- Fetched posts from API successfully ---")
                        await send(.postsLoaded(posts))
                    } catch {
                        logger.error("🔴 Fetch posts API data error: \(error.localizedDescription)")
                        await send(.error(error.localizedDescription))
                    }
                }
            case let .postsLoaded(posts):
                logger.info("--- Posts data loading complete successfully ---")
                return .run { send in
                    for post in posts {
                        try await dataBase.savePost(post)
                    }
                }
            case let .error(error):
                logger.error("🔴 Posts data fetch error \(error)")
                return .none
            }
        }
    }
}
