import ComposableArchitecture
import SwiftUI

struct CategoriesListFeature: Reducer {
    struct State: Equatable { 
        var categories: IdentifiedArrayOf<CategoryDTO> = []
    }
    
    enum Action: Equatable { 
        case addCategory(CategoryDTO)
        case dropDatabase
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
            }
        }
    }
}

struct CategoriesListView: View {
    
    let store: StoreOf<CategoriesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: \.categories) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.state) { category in
                        Text(category.title)
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
