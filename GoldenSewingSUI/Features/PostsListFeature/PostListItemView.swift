import SwiftUI

struct PostListItemView: View {
    
    let post: PostDTO
    
    var body: some View {
        VStack {
            RemoteImage(
                id: post.mainImage,
                width: UIScreen.main.bounds.width / 2)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.tint))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(post.link?.absoluteString ?? "")
                        .font(.caption)
                        .foregroundStyle(Color(.tint))
                        .fixedSize(horizontal: false, vertical: true)
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
    ZStack {
        Image(.background)
        
        PostListItemView(post: .mock)
            .frame(width: 150)
    }
}
