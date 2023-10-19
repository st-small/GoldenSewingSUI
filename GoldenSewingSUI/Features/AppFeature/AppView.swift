import ComposableArchitecture
import SwiftUI

struct AppReducer: Reducer {
    struct State: Equatable {
        var appDelegate: AppDelegateReducer.State = .init()
        var dataProvider: DataProvider.State = .init()
        var categoriesList: CategoriesListFeature.State = .init()
//        var postsList: PostsListFeature.State = .init()
    }
    enum Action: Equatable {
        case appDelegate(AppDelegateReducer.Action)
        case dataProvider(DataProvider.Action)
        case categoriesList(CategoriesListFeature.Action)
        case postsListFeature(PostsListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.appDelegate, action: /Action.appDelegate) {
            AppDelegateReducer()
        }
        Scope(state: \.categoriesList, action: /Action.categoriesList) {
            CategoriesListFeature()
        }
        Scope(state: \.dataProvider, action: /Action.dataProvider) {
            DataProvider()
        }
        
        Reduce { state, action in
            switch action {
            case .appDelegate(.scenePhaseActive):
                return .run { send in
                    await send(.dataProvider(.loadDBData))
                }
            case .categoriesList:
                return .none
            case .postsListFeature:
                return .none
            case let .dataProvider(.postsLoaded(cachedPosts)):
//                return .run { send in
//                    for post in cachedPosts {
//                        await send(.postsListFeature(.addPost(post)))
//                    }
//                }
                return .none
            case let .dataProvider(.categoriesLoaded(cachedCategories)):
                return .run { send in
                    for category in cachedCategories {
                        await send(.categoriesList(.addCategory(category)))
                    }
                }
            default:
                return .none
            }
        }
    }
}

struct AppView: View {
    
    let store: StoreOf<AppReducer>
    
    var body: some View {
        // It is need to check if it needs to show Onboarding here
        // Or start main user flow like a TabView or Starter module
        
        CategoriesListView(
            store: store.scope(
                state: \.categoriesList,
                action: { .categoriesList($0) }
            )
        )
    }
}
