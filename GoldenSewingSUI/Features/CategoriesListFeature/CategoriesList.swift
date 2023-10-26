import ComposableArchitecture
import SwiftUINavigation
import SwiftUI

struct CategoriesListFeature: Reducer {
    struct State: Equatable {
        var categories: IdentifiedArrayOf<CategoryDTO> = []
        
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
            }
        }
    }
}

struct CategoriesListView: View {
    
    let store: StoreOf<CategoriesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.categories) { category in
                        Text(category.title)
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
