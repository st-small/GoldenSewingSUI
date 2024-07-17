import ComposableArchitecture
import Dependencies
import SwiftUI

struct FavouritesFeature: Reducer {
    struct State: Equatable { 
        var favourites: IdentifiedArrayOf<PostDTO> = []
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        case onAppear
        case addFavourite(PostDTO)
        case removeTapped(PostDTO.ID)
        case path(StackAction<Path.State, Path.Action>)
        case onDisappear
    }
    
    @Dependency(\.coreData) var database
    
    private enum CancelID {
        case database
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.favourites = []
                return .run { send in
                    for post in try database.loadFavourites() {
                        await send(.addFavourite(post))
                    }
                    
                    for await event in await database.notify() {
                        switch event {
                        case let .didAddFavourite(postID):
                            print("<<< didAddFavourite \(postID)")
                        case let .didRemoveFavourite(postID):
                            print("<<< didRemoveFavourite \(postID)")
                        }
                    }
                }
                .cancellable(id: CancelID.database)
            case let .addFavourite(post):
                state.favourites.append(post)
                return .none
            case let .removeTapped(postID):
                state.favourites.remove(id: postID)
                return .run { send in
                    try database.updatePost(postID, false)
                }
            case .path:
                return .none
            case .onDisappear:
                return .cancel(id: CancelID.database)
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case postDetail(PostDetailFeature.State)
        }
        
        enum Action: Equatable {
            case postDetail(PostDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.postDetail, action: /Action.postDetail) {
                PostDetailFeature()
            }
        }
    }
}

struct FavouritesScreen: View {
    let store: StoreOf<FavouritesFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    Image(.background)
                        .resizable(resizingMode: .tile).ignoresSafeArea()
                    ScrollView {
                        ForEach(viewStore.favourites) { post in
                            HStack {
                                ZStack {
                                    RemoteImage(id: post.mainImage, width: 77)
                                        .cornerRadius(5)
                                }
                                .frame(width: 77, height: 77)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(post.title)
                                        .font(.custom("CyrillicOld", size: 15))
                                        .foregroundStyle(Color(.tint))
                                    
                                    Text(verbatim: "Артикул: \(post.id)")
                                        .font(.custom("CyrillicOld", size: 13))
                                        .foregroundStyle(Color(.tint))
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewStore.send(.removeTapped(post.id))
                                } label: {
                                    Image(systemName: "heart.fill")
                                }
                                .padding(.trailing, 10)
                                .tint(Color(.tint))

                            }
                            .background {
                                Color(.postBg)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(.main), for: .navigationBar)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("Избранное")
                            .foregroundStyle(Color(.tint))
                            .font(.custom("CyrillicOld", size: 17))
                    }
                })
            }
            .onAppear {
                store.send(.onAppear)
            }
            .onDisappear {
                store.send(.onDisappear)
            }
        } destination: { store in
            switch store {
            case .postDetail:
                CaseLet(/CategoriesListFeature.Path.State.postDetail, action: CategoriesListFeature.Path.Action.postDetail) { store in
                    PostDetailView(store: store)
                }
            }
        }
    }
}

#Preview {
    FavouritesScreen(
        store: Store(
            initialState: FavouritesFeature.State(
                favourites: [.mock, .mock2]
            )) {
            FavouritesFeature()
        })
}
