import ComposableArchitecture

struct MediaProvider: Reducer {
    struct State: Equatable { }
    
    enum Action: Equatable {
        case fetchAPIData
        case mediaLoaded([MediaDTO])
        case error(String)
    }
    
    @Dependency(\.apiClient) var api
    @Dependency(\.coreData) var dataBase
    @Dependency(\.logger) var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchAPIData:
                logger.info("--- Try to fetch media from API ---")
                return .run { send in
                    do {
                        let media = try await api.fetchMedia()
                        logger.info("--- Fetched media from API successfully ---")
                        await send(.mediaLoaded(media))
                    } catch {
                        logger.error("🔴 Fetch media API data error: \(error.localizedDescription)")
                        await send(.error(error.localizedDescription))
                    }
                }
            case let .mediaLoaded(mediaItems):
                logger.info("--- Media data loading complete successfully ---")
                return .run { send in
                    for media in mediaItems {
                        try await dataBase.saveMedia(media)
                    }
                }
            case let .error(error):
                logger.error("🔴 Media data fetch error \(error)")
                return .none
            }
        }
    }
}
