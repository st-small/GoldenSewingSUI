import Foundation
import ModelsKit
import SwiftData

@Model
public final class SDImageEntity {
    @Attribute(.unique)
    public var id: UInt32
    public var link: String
    @Attribute(.externalStorage)
    public var imageData: Data?
    public var product: SDProductEntity?
    
    public init(
        id: UInt32,
        link: String,
        imageData: Data? = nil,
        product: SDProductEntity? = nil
    ) {
        self.id = id
        self.link = link
        self.imageData = imageData
        self.product = product
    }
    
    public init?(_ model: ImageModel?) {
        guard let model else { return nil }
        self.id = model.id.value
        self.link = model.link
    }
}

extension SDImageEntity {
    func imageModel() -> ImageModel {
        ImageModel(
            id: ImageID(id),
            link: link,
            image: imageData
        )
    }
}
