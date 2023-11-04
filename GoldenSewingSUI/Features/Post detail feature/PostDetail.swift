import ComposableArchitecture
import SwiftUI

struct PostDetailFeature: Reducer {
    struct State: Equatable { 
        var post: PostDTO
    }
    
    enum Action: Equatable {
        case toggleFavourite
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleFavourite:
                return .none
            }
        }
    }
}

struct PostDetailView: View {
    let store: StoreOf<PostDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text("ID: \(viewStore.post.id)")
                Text("Title: \(viewStore.post.title)")
                Text("Category: \(viewStore.post.categories.first ?? -1)")
                
                AsyncImage(id: viewStore.post.mainImage) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image.resizable().scaledToFit()
                    case let .failure(error):
                        Button("Повтор") {
                            
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(viewStore.post.title)
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(
            store: Store(initialState: PostDetailFeature.State(post: .mock)) {
                PostDetailFeature()
            }
        )
    }
}
