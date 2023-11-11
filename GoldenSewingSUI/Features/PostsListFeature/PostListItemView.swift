import SwiftUI

struct PostListItemView: View {
    
    let post: PostDTO
    
    var body: some View {
        VStack {
            RemoteImage(post.mainImage, maxWidth: UIScreen.main.bounds.width/2)
//            AsyncImage(id: post.mainImage) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case let .success(image):
//                    image.resizable().scaledToFit()
//                        .clipped()
//                case let .failure(error):
//                    Text(error.localizedDescription)
//                }
//            }
//            Image(Int.random(in: 0...10).isMultiple(of: 2) ? .one : .ten)
//                .resizable()
//                .scaledToFit()
            
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
