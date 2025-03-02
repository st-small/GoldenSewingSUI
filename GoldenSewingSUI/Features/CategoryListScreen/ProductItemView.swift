import ModelsKit
import SwiftUI
import Utilities

public struct ProductItemView: View {
    @Environment(\.imageLoader) private var imageLoader
    @Injected(\.favsObserver) private var favsObserver
    
    let product: ProductModel
    
    @State private var image: Image?
    @State private var imageSize: CGSize = .zero
    @State private var isFavourite = false
    @State private var error: String?
    
    private var showFavIcon: Bool {
        image != nil && isFavourite
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            imageContainer
            
            Spacer(minLength: 10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxHeight: .infinity)
                
                Text("Артикул: \(product.id.value)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(0x3C3C43))
                    .opacity(0.6)
            }
        }
        .task {
            await loadImage()
            
            isFavourite = favsObserver.favourites.contains(where: { $0.id == product.id })
        }
    }
    
    private var imageContainer: some View {
        GeometryReader { geo in
            Color.gray.opacity(0.3)
                .onAppear {
                    imageSize = geo.size
                }
            
            if error != nil {
                errorView
            } else if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .hSpacing()
                    .vSpacing()
            }
        }
        .frame(height: 170)
        .clipShape(
            .rect(cornerRadius: 10)
        )
        .overlay {
            Button {
                isFavourite.toggle()
                favsObserver.updateProduct(product)
            } label: {
                Image(systemName: "heart.fill")
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.red)
                    .shadow(color: .white, radius: 3)
                    .padding([.top, .trailing], 5)
            }
            .hSpacing(.trailing)
            .vSpacing(.top)
            .opacity(showFavIcon ? 1 : 0)
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            
            Text(error!)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .hSpacing()
        .vSpacing()
    }
    
    private func loadImage() async {
        guard let imageModel = product.images?.first(where: { $0.isMain == true }) else { return }
        
        do {
            let uiImage = try await imageLoader.getImage(
                imageModel,
                width: imageSize.width,
                height: imageSize.height
            )
            image = Image(uiImage: uiImage)
        } catch {
            self.error = error.localizedDescription
        }
    }
}

#Preview {
    ProductItemView(product: .mockWithImage)
        .frame(width: 167, height: 240)
        .border(.green)
}
