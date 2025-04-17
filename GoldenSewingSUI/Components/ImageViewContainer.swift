import ModelsKit
import SwiftUI

public struct ImageViewContainer: View {
    @Environment(\.imageLoader) private var imageLoader
    
    let model: ImageModel
	let mode: ContentMode
    let onTapped: () -> Void
    
    @State private var image: Image?
    @State private var imageSize: CGSize = .zero
    @State private var error: String?
	
	public init(
		model: ImageModel,
		mode: ContentMode = .fit,
		onTapped: @escaping () -> Void
	) {
		self.model = model
		self.mode = mode
		self.onTapped = onTapped
	}
    
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
							.aspectRatio(contentMode: mode)
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
						.background(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color(0x871A1A).opacity(0.3), lineWidth: 1)
								.frame(width: imageSize.width, height: imageSize.height)
						)
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
			withAnimation {
				image = Image(uiImage: uiImage)
			}
        } catch {
            self.error = error.localizedDescription
        }
    }
}
