import ComposableArchitecture
import SwiftUI

enum Tab {
    case categories, favourites, green
}

struct AppFeature: Reducer {
    struct State: Equatable { 
        var categories = CategoriesListFeature.State()
        var favouritesTab = FavouritesFeature.State()
        var greenTab = GreenTabFeature.State()
        var categoriesDataProvider = CategoriesProvider.State()
        var postsDataProvider = PostsProvider.State()
        var mediaDataProvider = MediaProvider.State()
        var selectedTab: Tab = .categories
    }
    
    enum Action: Equatable {
        case categoriesTab(CategoriesListFeature.Action)
        case favouritesTab(FavouritesFeature.Action)
        case greenTab(GreenTabFeature.Action)
        case categoriesDataProvider(CategoriesProvider.Action)
        case postsDataProvider(PostsProvider.Action)
        case mediaDataProvider(MediaProvider.Action)
        case selectedTabChanged(Tab)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.favouritesTab, action: /Action.favouritesTab) {
            FavouritesFeature()
        }
        Scope(state: \.categories, action: /Action.categoriesTab) {
            CategoriesListFeature()
        }
        Scope(state: \.greenTab, action: /Action.greenTab) {
            GreenTabFeature()
        }
        Scope(state: \.categoriesDataProvider, action: /Action.categoriesDataProvider) {
            CategoriesProvider()
        }
        Scope(state: \.postsDataProvider, action: /Action.postsDataProvider) {
            PostsProvider()
        }
        Scope(state: \.mediaDataProvider, action: /Action.mediaDataProvider) {
            MediaProvider()
        }
    }
}

struct AppFeatureView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0.selectedTab },
                send: AppFeature.Action.selectedTabChanged)
            ) {
                Group {
                    CategoriesListView(store: store.scope(
                        state: \.categories,
                        action: AppFeature.Action.categoriesTab)
                    )
                    .tabItem {
                        Label("Категории", image: .categoriesTabIcon)
                    }
                    .tag(Tab.categories)
                    
                    FavouritesScreen(store: store.scope(
                        state: \.favouritesTab,
                        action: AppFeature.Action.favouritesTab)
                    )
                    .tabItem {
                        Label("Избранное", image: .favouritesTabIcon)
                    }
                    .tag(Tab.favourites)
                    
                    GreenTabView(store: store.scope(
                        state: \.greenTab,
                        action: AppFeature.Action.greenTab)
                    )
                    .tabItem { Text("Green") }
                    .tag(Tab.green)
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color(.main), for: .tabBar)
            }
            .accentColor(.tint)
            .onAppear {
                viewStore.send(.categoriesDataProvider(.loadDBData))
                viewStore.send(.postsDataProvider(.loadDBData))
                viewStore.send(.mediaDataProvider(.fetchAPIData))
            }
        }
    }
}

#Preview {
    AppFeatureView(
        store: Store(
            initialState: AppFeature.State(),
            reducer: {
                AppFeature()
            }
        )
    )
}
