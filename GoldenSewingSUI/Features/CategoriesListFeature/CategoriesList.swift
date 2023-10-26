import ComposableArchitecture
import SwiftUINavigation
import SwiftUI

struct CategoriesListFeature: Reducer {
    struct State: Equatable {
        var categories: IdentifiedArrayOf<CategoryDTO> = []
        var path = StackState<PostsListFeature.State>()
        
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
        case path(StackAction<PostsListFeature.State, PostsListFeature.Action>)
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
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            PostsListFeature()
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
                        NavigationLink(state: PostsListFeature.State(category: category)) {
                            Text(category.title)
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
            PostsListView(store: store)
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
