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
    
    init() {
        let searchImage = UIImage(resource: .searchIcon).withTintColor(UIColor(resource: .tint).withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        UISearchBar.appearance().setImage(searchImage, for: .search, state: .normal)
        
        let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(UIColor(resource: .tint).withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        UISearchBar.appearance().setImage(clearImage, for: .clear, state: .normal)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(resource: .searchBg)
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor(resource: .tint).withAlphaComponent(0.4),
                .font: UIFont(name: "TimesNewRomanPS-ItalicMT", size: 17) ?? .systemFont(ofSize: 17)
            ])
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
                state.path.append(.postDetail(.init(post: value)))
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
            case postDetail(PostDetailFeature.State)
        }
        
        enum Action: Equatable {
            case posts(PostsListFeature.Action)
            case postDetail(PostDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.posts, action: /Action.posts) {
                PostsListFeature()
            }
            Scope(state: /State.postDetail, action: /Action.postDetail) {
                PostDetailFeature()
            }
        }
    }
}

struct CategoriesListView: View {
    
    let store: StoreOf<CategoriesListFeature>
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 0),
    ]
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    Image(.background)
                        .resizable(resizingMode: .tile).ignoresSafeArea()
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.categories) { category in
                                ZStack {
                                    Image(.categoryBackground)
                                        .resizable()
                                        .scaledToFill()
                                    
                                    VStack {
                                        category.image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                        
                                        Text(category.title)
                                            .font(.custom("CyrillicOld", size: 13))
                                            .foregroundStyle(Color(.title))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                }
                                .frame(height: 93)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(.tint), lineWidth: 1)
                                }
                                .shadow(
                                    color: Color(.categoryShadow),
                                    radius: 8, x: 0, y: 2)
                                .onTapGesture {
                                    viewStore.send(.selectCategory(category))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(.main), for: .navigationBar)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("Категории")
                            .foregroundStyle(Color(.tint))
                            .font(.custom("CyrillicOld", size: 17))
                    }
                })
            }
        } destination: { store in
            switch store {
            case .posts:
                CaseLet(/CategoriesListFeature.Path.State.posts, action: CategoriesListFeature.Path.Action.posts) { store in
                    PostsListView(store: store)
                }
            case .postDetail:
                CaseLet(/CategoriesListFeature.Path.State.postDetail, action: CategoriesListFeature.Path.Action.postDetail) { store in
                    PostDetailView(store: store)
                }
            }
        }
        .searchable(text: .constant(""), prompt: "Поиск") {
            
        }
    }
}

#Preview {
    CategoriesListView(
        store: Store(
            initialState: CategoriesListFeature.State(categories: [.mock, .mock2])) {
        CategoriesListFeature()
    })
}
