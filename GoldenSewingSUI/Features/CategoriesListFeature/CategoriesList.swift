import ComposableArchitecture
import SwiftUINavigation
import SwiftUI

struct CategoriesListFeature: Reducer {
    struct State: Equatable {
        var categories: IdentifiedArrayOf<CategoryDTO> = []
        var path = StackState<Path.State>()
        
        init(categories: [CategoryDTO] = []) {
            if categories.isEmpty {
                @Dependency(\.categoriesDataSource) var data
                data.loadCategories().forEach { self.categories.append($0) }
            } else {
                self.categories.append(contentsOf: categories)
            }
        }
    }
    
    enum Action: Equatable {
        case addCategory(CategoryDTO)
        case dropCategoriesTapped
        case selectCategory(CategoryDTO)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.coreData) var dataBase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .addCategory(category):
                state.categories.append(category)
                return .none
            case .dropCategoriesTapped:
                return .run { send in
                    try await dataBase.dropCategories()
                }
            case let .selectCategory(category):
                state.path.append(.posts(.init(category: category)))
                return .none
            case let .path(.element(id: _, action: .posts(.delegate(.postDetail(value))))):
                state.path.append(.posts(.init(category: .mock)))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case posts(PostsListFeature.State)
            case postDetail(PostsListFeature.State)
        }
        
        enum Action: Equatable {
            case posts(PostsListFeature.Action)
            case postDetail(PostsListFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.posts, action: /Action.posts) {
                PostsListFeature()
            }
        }
    }
}

struct CategoriesListView: View {
    
    let store: StoreOf<CategoriesListFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                List {
                    ForEach(viewStore.categories) { category in
                        Text(category.title)
                            .onTapGesture {
                                viewStore.send(.selectCategory(category))
                            }
                    }
                }
                .navigationTitle("Categories")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Drop") {
                            viewStore.send(.dropCategoriesTapped)
                        }
                    }
                }
            }
        } destination: { store in
            switch store {
            case .posts:
                CaseLet(/CategoriesListFeature.Path.State.posts, action: CategoriesListFeature.Path.Action.posts) { store in
                    PostsListView(store: store)
                }
            case .postDetail:
                CaseLet(/CategoriesListFeature.Path.State.posts, action: CategoriesListFeature.Path.Action.posts) { store in
                    PostsListView(store: store)
                }
            }
        }
    }
}

#Preview {
    CategoriesListView(
        store: Store(
            initialState: CategoriesListFeature.State(categories: [.mock])) {
        CategoriesListFeature()
    })
}
