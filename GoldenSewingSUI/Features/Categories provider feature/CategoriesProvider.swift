import ComposableArchitecture
import Foundation

struct CategoriesProvider: Reducer {
    struct State: Equatable { }
    
    enum Action: Equatable {
        case loadCategoriesDiskData
        case loadDBData
        case fetchAPIData
        case categoriesLoaded([CategoryDTO])
        case error(String)
    }
    
    @Dependency(\.coreData) var dataBase
    @Dependency(\.diskDataLoader.loadCategories) var cached
    @Dependency(\.apiClient) var api
    @Dependency(\.logger) var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadCategoriesDiskData:
                logger.info("--- Try to load categories from cached data ---")
                return .run { send in
                    do {
                        await send(.categoriesLoaded(try cached()))
                    } catch {
                        await send(.error(error.localizedDescription))
                        logger.error("🔴 Cached categories disk data error: \(error.localizedDescription)")
                    }
                }
            case .loadDBData:
                logger.info("--- Try to fetch categories from DB ---")
                return .run { send in
                    do {
                        let categories = try dataBase.loadCategories()
                        if categories.isEmpty {
                            await send(.loadCategoriesDiskData)
                        } else {
                            await send(.categoriesLoaded(categories))
                        }
                    } catch {
                        logger.error("🔴 Load DB data error: \(error.localizedDescription)")
                        await send(.error(error.localizedDescription))
                    }
                }
                .merge(with: .run(operation: { send in
                    await send(.fetchAPIData)
                }))
            case .fetchAPIData:
                logger.info("--- Try to fetch categories from API ---")
                return .run { send in
                    do {
                        let categories = try await api.fetchCategories()
                        await send(.categoriesLoaded(categories))
                    } catch {
                        logger.error("🔴 Fetch categories API data error: \(error.localizedDescription)")
                        await send(.error(error.localizedDescription))
                    }
                }
            case let .categoriesLoaded(categories):
                logger.info("--- Categories data loading complete successfully ---")
                return .run { send in
                    for category in categories {
                        try await dataBase.saveCategory(category)
                    }
                }
            case let .error(error):
                logger.error("🔴 Data loading error \(error)")
                return .none
            }
        }
    }
}
