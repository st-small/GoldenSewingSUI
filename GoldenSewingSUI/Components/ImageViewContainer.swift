import ModelsKit
import SwiftUI

public struct ImageViewContainer: View {
    @Environment(\.imageLoader) private var imageLoader
    
    let model: ImageModel
    let onTapped: () -> Void
    
    @State private var image: Image?
    @State private var imageSize: CGSize = .zero
    @State private var error: String?
    
    public var body: some View {
        GeometryReader { geo in
            Group {
                if error != nil {
                    errorView
                } else if let image {
                    Button {
                        onTapped()
                    } label: {
                        image
                            .resizable()
                            .scaledToFit()
                    }
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
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            
            Text(error!)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .hSpacing()
        .vSpacing()
    }
    
    private func loadImage() async {
        do {
            let uiImage = try await imageLoader.getImage(
                model,
                width: imageSize.width,
                height: imageSize.height
            )
            image = Image(uiImage: uiImage)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
