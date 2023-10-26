import ComposableArchitecture
import SwiftUI

enum Tab {
    case categories, red, green
}

struct AppFeature: Reducer {
    struct State: Equatable { 
        var categories = CategoriesListFeature.State()
        var redTab = RedTabFeature.State()
        var greenTab = GreenTabFeature.State()
        var categoriesDataProvider = CategoriesProvider.State()
        var selectedTab: Tab = .categories
    }
    
    enum Action: Equatable {
        case categoriesTab(CategoriesListFeature.Action)
        case redTab(RedTabFeature.Action)
        case greenTab(GreenTabFeature.Action)
        case categoriesDataProvider(CategoriesProvider.Action)
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
        Scope(state: \.redTab, action: /Action.redTab) {
            RedTabFeature()
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
                CategoriesListView(store: store.scope(
                    state: \.categories,
                    action: AppFeature.Action.categoriesTab)
                )
                .tabItem { Text("Categories") }
                .tag(Tab.categories)
                
                RedTabView(store: store.scope(
                    state: \.redTab,
                    action: AppFeature.Action.redTab)
                )
                .tabItem { Text("Red") }
                .tag(Tab.red)
                
                GreenTabView(store: store.scope(
                    state: \.greenTab,
                    action: AppFeature.Action.greenTab)
                )
                .tabItem { Text("Green") }
                .tag(Tab.green)
            }
            .onAppear {
                viewStore.send(.categoriesDataProvider(.loadDBData))
            }
        }
    }
}
