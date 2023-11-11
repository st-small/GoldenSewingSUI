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
            ZStack {
                Image(.background)
                    .resizable(resizingMode: .tile).ignoresSafeArea()
                ScrollView {
                    PostsLayoutView(
                        posts: viewStore.posts,
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
    }
    /*
    private func postCardView(_ post: PostDTO) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.postBg))
            
            VStack {
                AsyncImage(id: post.mainImage) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image.resizable().scaledToFit()
                    case let .failure(error):
                        Text(error.localizedDescription)
                    }
                }
                
                Rectangle()
                    .fill(Color(.tint))
                    .frame(height: 79)
            }
        }
        .cornerRadius(10)
        .onTapGesture {
            store.send(.delegate(.postDetail(post)))
        }
    }
     */
    private func postCardView(_ post: PostDTO) -> some View {
        VStack {
            RemoteImage(post.mainImage, maxWidth: UIScreen.main.bounds.width/2)
            
//            AsyncImage(id: post.mainImage) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case let .success(image):
//                    image.resizable().scaledToFit()
//                case let .failure(error):
//                    Text(error.localizedDescription)
//                }
//            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.tint))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(post.link?.absoluteString ?? "")
                        .font(.caption)
                        .foregroundStyle(Color(.tint))
                }
                
                Spacer()
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .cornerRadius(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.tint))
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
