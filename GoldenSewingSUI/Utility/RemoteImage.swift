import Dependencies
import Kingfisher
import SwiftUI

struct RemoteImage: View {
    
    @Dependency(\.logger) var logger
    @Dependency(\.coreData) var coreData
    
    private let id: Int32
    private let width: CGFloat
    private var url: URL? {
        return try? coreData.loadMedia(id)?.sourceUrl
    }
    
    init(id: Int32, width: CGFloat) {
        self.id = id
        self.width = width
    }
    
    var body: some View {
        KFImage.url(url)
            .resizable()
            .onSuccess { result in
                logger.info("Post image loaded success \(result.cacheType)")
            }
            .onFailure { error in
                logger.error("Post loading failed \(error)")
            }
            .placeholder {
                VStack {
                    ProgressView("Загрузка...")
                        .tint(.tint)
                }
                .foregroundColor(.tint)
            }
            .fade(duration: 1)
            .cancelOnDisappear(false)
            .resizing(referenceSize: CGSize(width: width, height: .greatestFiniteMagnitude), mode: .aspectFit)
            .aspectRatio(contentMode: .fit)
    }
}
