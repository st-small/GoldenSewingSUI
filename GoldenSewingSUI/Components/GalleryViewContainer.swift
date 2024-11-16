import ModelsKit
import SwiftUI

public struct GalleryViewContainer: View {
    @Environment(\.imageLoader) private var imageLoader
    
    let model: ImageModel
    
    @State private var image: Image?
    @State private var imageSize: CGSize = .zero
    @State private var error: String?
    
    public var body: some View {
        GeometryReader { geo in
            Group {
                if let error {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        
                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .hSpacing()
                    .vSpacing()
                } else if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .hSpacing()
            .vSpacing()
            .onAppear {
                imageSize = geo.size
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        do {
            let uiImage = try await imageLoader.getFullImage(model)
            image = Image(uiImage: uiImage)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
