import ComposableArchitecture
import CoreData
import SwiftUI

struct PostsListFeature: Reducer {
    struct State: Equatable {
        var category: CategoryDTO
        var posts: IdentifiedArrayOf<PostDTO> = []
        
        init(category: CategoryDTO, posts: [PostDTO] = []) {
            self.category = category
            
            if posts.isNotEmpty {
                self.posts.append(contentsOf: posts)
            }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case loadedPost(PostDTO)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case addFavouriteTapped(PostDTO.ID)
            case removeFavouriteTapped(PostDTO.ID)
            case postDetail(PostDTO)
        }
    }
    
    @Dependency(\.coreData) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [id = state.category.id] send in
                    @Dependency(\.postsDataSource) var data
                    for post in data.loadPosts(id) {
                        await send(.loadedPost(post))
                    }
                }
            case let .loadedPost(post):
                state.posts.append(post)
                return .none
            case let .delegate(.addFavouriteTapped(id)):
                withAnimation {
                    state.posts[id: id]?.isFavourite = true
                }
                return .run { send in
                    try await database.updatePost(id, true)
                }
            case let .delegate(.removeFavouriteTapped(id)):
                withAnimation {
                    state.posts[id: id]?.isFavourite = false
                }
                return .run { send in
                    try await database.updatePost(id, false)
                }
            default:
                return .none
            }
        }
    }
}

struct PostsListView: View {
    let store: StoreOf<PostsListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Image(.background)
                    .resizable(resizingMode: .tile).ignoresSafeArea()
                ScrollView {
                    PostsLayoutView(
                        posts: viewStore.posts,
                        addFavourite: { store.send(.delegate(.addFavouriteTapped($0))) },
                        deleteFavourite: { store.send(.delegate(.removeFavouriteTapped($0))) },
                        postTapped: { store.send(.delegate(.postDetail($0)))
                        }
                    )
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(viewStore.category.title)
                        .foregroundStyle(Color(.tint))
                        .font(.custom("CyrillicOld", size: 15))
                }
            })
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        PostsListView(
            store: Store(
                initialState: PostsListFeature.State(
                    category: CategoryDTO.mock,
                    posts: [PostDTO.mock]
                )
            ) {
                PostsListFeature()
            }
        )
    }
}
