import ComposableArchitecture
import SwiftUI

struct PostsListFeature: Reducer {
    struct State: Equatable { 
        var posts: IdentifiedArrayOf<PostDTO> = []
    }
    enum Action: Equatable { 
        case addPost(PostDTO)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { 
            case let .addPost(post):
                state.posts.append(post)
                return .none
            }
        }
    }
}

struct PostsListView: View {
    let store: StoreOf<PostsListFeature>
    
    var body: some View {
        WithViewStore(store, observe: \.posts) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.state) { post in
                        Text("\(post.id)")
                    }
                }
                .navigationTitle("Posts")
            }
        }
    }
}

//#Preview {
//    PostsListView(
//        store: Store(
//            initialState: PostsListFeature.State(posts: [Post.mock])
//        ) {
//            PostsListFeature()
//        }
//    )
//}
