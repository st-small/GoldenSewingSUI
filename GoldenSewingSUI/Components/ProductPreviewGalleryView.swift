import ModelsKit
import SwiftUI

public struct ProductPreviewGalleryView: View {
    var images: [ImageModel]
    
    @State private var selectedIndex: Int = 0
    @State private var showGallery: Bool = false
    
    public init(_ models: [ImageModel]?) {
        self.images = models ?? []
        
        if let idx = images.firstIndex(where: { $0.isMain }) {
            images.swapAt(idx, 0)
        }
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            tabView
            
            if images.count > 1 {
                pageIndexesView
            }
        }
        .fullScreenCover(isPresented: $showGallery) {
            ProductGalleryView(
                showGallery: $showGallery,
                currentIndex: $selectedIndex,
                images: images
            )
        }
    }
    
    private var tabView: some View {
        ZStack {
            Color(0xF2F2F7)
            
                TabView(selection: $selectedIndex) {
                    imagesView
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(height: 230)
        .clipShape(.rect(cornerRadius: 6))
    }
    
    private var imagesView: some View {
        ForEach(0..<images.count, id: \.self) { index in
            ZStack {
                ImageViewContainer(
                    model: images[index],
                    onTapped: {
                        withAnimation {
                            showGallery.toggle()
                        }
                    }
                )
            }
        }
        .clipped()
    }
    
    private var pageIndexesView: some View {
        HStack {
            ForEach(0..<images.count, id: \.self) { index in
                Circle()
                    .fill(
                        index == selectedIndex
                        ? .black
                        : Color(0x3C3C43).opacity(0.3)
                    )
                    .frame(width: 4, height: 4)
            }
        }
        .hSpacing()
    }
}




