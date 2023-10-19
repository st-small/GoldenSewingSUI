import ComposableArchitecture
import CoreData
import SwiftUI

struct PostsListFeature: Reducer {
    struct State: Equatable { 
        var category: CategoryDTO
        var posts: IdentifiedArrayOf<PostDTO> = []
    }
    enum Action: Equatable { 
        case onAppear
        case loadPosts([PostDTO])
    }
    
    @Dependency(\.coreData) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { 
            case .onAppear:
                let categoryID = state.category.id
                return .run { send in
                    let predicate = NSPredicate(format: "category == %d", categoryID)
                    await send(.loadPosts(try await database.loadPosts(predicate)))
                }
            case let .loadPosts(posts):
                state.posts.append(contentsOf: posts)
                return .none
            }
        }
    }
}

struct PostsListView: View {
    let store: StoreOf<PostsListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.posts) { post in
                    Text(post.title)
                }
            }
            .navigationTitle("Category \(viewStore.category.id) \(viewStore.category.title)")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
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
