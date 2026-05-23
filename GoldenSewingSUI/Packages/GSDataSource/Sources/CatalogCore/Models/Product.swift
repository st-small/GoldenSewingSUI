import Foundation
import SQLiteData

@Table
public nonisolated struct Product: Identifiable, Hashable, Sendable {
    public let id: Int32
    public var categoryId: Int32
    public var name: String = ""
    public var slug: String = ""
    public var link: String = ""
    public var date: String = ""
    public var imageURL: String = ""
    public var thumbnailURL: String = ""
    public var isOffer: Bool = false
    public var isBestOffer: Bool = false
    // JSON-массив URL дополнительных изображений: ["https://..."]
    public var additionalImages: String = "[]"
}

extension Product {
    init(from dto: ProductJSON) {
        id = dto.id
        categoryId = dto.categories.first ?? 0
        name = dto.title.rendered
        slug = dto.slug
        link = dto.link
        date = dto.date
        imageURL = dto.betterFeaturedImage?.sourceUrl ?? ""
        thumbnailURL = dto.betterFeaturedImage?.mediaDetails?.sizes?.catalogThumbnail?.sourceUrl ?? ""
        isOffer = dto.acf?.offer ?? false
        isBestOffer = dto.acf?.bestOffer ?? false
        let urls = dto.acf?.addImg?.map(\.subImgUrl) ?? []
        additionalImages = (try? String(data: JSONEncoder().encode(urls), encoding: .utf8)) ?? "[]"
    }
}
