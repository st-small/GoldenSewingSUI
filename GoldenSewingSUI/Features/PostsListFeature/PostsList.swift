import ComposableArchitecture
import CoreData
import SwiftUI

struct PostsListFeature: Reducer {
    struct State: Equatable {
        var category: CategoryDTO
        var posts: IdentifiedArrayOf<PostDTO> = []
        
        init(category: CategoryDTO, posts: [PostDTO] = []) {
            self.category = category
            
            if posts.isEmpty {
                @Dependency(\.postsDataSource) var data
                data.loadPosts(category.id).forEach { self.posts.append($0) }
            } else {
                self.posts.append(contentsOf: posts)
            }
        }
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case postDetail(PostDTO)
        }
    }
    
    @Dependency(\.coreData) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
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
                        .onTapGesture {
                            viewStore.send(.delegate(.postDetail(post)))
                        }
                }
            }
            .navigationBarTitle(viewStore.category.title)
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
