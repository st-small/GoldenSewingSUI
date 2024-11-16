import ModelsKit
import SwiftUI

public struct ProductGalleryView: View {
    @Binding var showGallery: Bool
    @Binding var currentIndex: Int
    
    let images: [ImageModel]
    
    @State private var offset: CGSize = .zero
    
    public var body: some View {
        NavigationStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    GalleryViewContainer(
                        model: images[index]
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.bottom, 40)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            showGallery.toggle()
                        }
                    } label: {
                        Text("Отмена")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(currentIndex + 1)/\(images.count)")
                }
            }
        }
        .colorScheme(.dark)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width < 50 {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(offset.height) > 100 {
                        showGallery.toggle()
                    } else {
                        offset = .zero
                    }
                }
        )
    }
}
