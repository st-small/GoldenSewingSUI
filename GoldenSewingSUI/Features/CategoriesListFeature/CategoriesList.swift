import ComposableArchitecture
import SwiftUINavigation
import SwiftUI

struct CategoriesListFeature: Reducer {
    struct State: Equatable { 
        var categories: IdentifiedArrayOf<CategoryDTO> = []
        var path = StackState<PostsListFeature.State>()
    }
    
    enum Action: Equatable { 
        case addCategory(CategoryDTO)
        case dropDatabase
        case path(StackAction<PostsListFeature.State, PostsListFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .addCategory(category):
                state.categories.append(category)
                return .none
            case .dropDatabase:
                return .run { send in
                    @Dependency(\.coreData) var database
                    @Dependency(\.logger) var logger
                    do {
                        try await database.dropPosts()
                    } catch {
                        logger.error("🔴 Drop database error \(error.localizedDescription)")
                    }
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
            WithViewStore(store, observe: \.categories) { viewStore in
                NavigationView {
                    List {
                        ForEach(viewStore.state) { category in
                            NavigationLink(
                                state: PostsListFeature.State(category: category),
                                label: { Text(category.title) }
                            )
                        }
                    }
                    .navigationTitle("Categories")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Drop database") {
                                viewStore.send(.dropDatabase)
                            }
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
            initialState: CategoriesListFeature.State(
                categories: [CategoryDTO.mock])
        ) {
            CategoriesListFeature()
        }
    )
}
