import SwiftUI

struct PostListItemView: View {
    
    let post: PostDTO
    var addFavourite: (PostDTO.ID) -> Void
    var deleteFavourite: (PostDTO.ID) -> Void
    
    var body: some View {
        VStack {
            RemoteImage(
                id: post.mainImage,
                width: UIScreen.main.bounds.width / 2)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(post.title)
                            .font(.custom("CyrillicOld", size: 15))
                            .foregroundStyle(Color(.tint))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.top, .leading], 8)
                        
                        Spacer()
                        
                        Button {
                            post.isFavourite ? deleteFavourite(post.id) : addFavourite(post.id)
                        } label: {
                            Image(systemName: post.isFavourite ? "heart.fill" : "heart")
                        }
                        .tint(.tint)
                        .padding(.top, 8)
                    }
                    
                    Text(verbatim: "Артикул \(post.id)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color(.tint))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.all, 8)
                }
                
                Spacer()
            }
        }
        .cornerRadius(10)
        .background {
            Color(.postBg).cornerRadius(10)
        }
    }
}

#Preview {
    ZStack {
        Image(.background)
        
        HStack(alignment: .top) {
            PostListItemView(
                post: .mock,
                addFavourite: { _ in },
                deleteFavourite: { _ in }
            )
            .frame(width: 150)
            
            PostListItemView(
                post: .mock2,
                addFavourite: { _ in },
                deleteFavourite: { _ in }
            )
            .frame(width: 150)
        }
    }
}
