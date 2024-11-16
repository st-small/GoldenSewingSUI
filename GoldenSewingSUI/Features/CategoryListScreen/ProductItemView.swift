import ModelsKit
import SwiftUI
import Utilities

public struct ProductItemView: View {
    @Environment(\.imageLoader) private var imageLoader
    
    let product: ProductModel
    
    @State private var image: Image?
    @State private var imageSize: CGSize = .zero
    @State private var error: String?
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                imageContainer
                
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
                    .border(.cyan)
                
                Text("Артикул: \(product.id.value)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(0x3C3C43))
                    .opacity(0.6)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private var imageContainer: some View {
        GeometryReader { geo in
            Color.gray.opacity(0.3)
                .onAppear {
                    imageSize = geo.size
                }
            
            if let error {
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
        guard let imageModel = product.images?.first else { return }
        
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
