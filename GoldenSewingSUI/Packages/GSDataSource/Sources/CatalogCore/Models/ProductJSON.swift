import Foundation

// WordPress REST API /wp/v2/posts формат.
// Используем: id, slug, link, date, title.rendered, categories[], better_featured_image, acf.
// Лишние поля (_links, meta, guid, excerpt, content и др.) игнорируются автоматически.
struct ProductJSON: Decodable {
    let id: Int32
    let slug: String
    let link: String
    let date: String
    let title: RenderedContent
    let categories: [Int32]
    let betterFeaturedImage: BetterFeaturedImage?
    let acf: ACF?

    struct RenderedContent: Decodable {
        let rendered: String
    }

    struct BetterFeaturedImage: Decodable {
        let sourceUrl: String
        let mediaDetails: MediaDetails?

        struct MediaDetails: Decodable {
            let sizes: Sizes?

            struct Sizes: Decodable {
                let catalogThumbnail: ImageSize?
                let singleThumbnail: ImageSize?

                enum CodingKeys: String, CodingKey {
                    case catalogThumbnail = "catalog-thumbnail"
                    case singleThumbnail = "single-thumbnail"
                }

                struct ImageSize: Decodable {
                    let sourceUrl: String

                    enum CodingKeys: String, CodingKey {
                        case sourceUrl = "source_url"
                    }
                }
            }

            enum CodingKeys: String, CodingKey {
                case sizes
            }
        }

        enum CodingKeys: String, CodingKey {
            case sourceUrl = "source_url"
            case mediaDetails = "media_details"
        }
    }

    struct ACF: Decodable {
        let offer: Bool?
        let bestOffer: Bool?
        let addImg: [AddImage]?

        struct AddImage: Decodable {
            let subImgUrl: String

            enum CodingKeys: String, CodingKey {
                case subImgUrl = "sub_img_url"
            }
        }

        enum CodingKeys: String, CodingKey {
            case offer
            case bestOffer = "best_offer"
            case addImg = "add_img"
        }

        // WordPress ACF возвращает `false` (Bool) вместо `null`/`[]` для пустых полей.
        init(from decoder: any Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            offer = try c.decodeIfPresent(Bool.self, forKey: .offer)
            bestOffer = try c.decodeIfPresent(Bool.self, forKey: .bestOffer)
            // add_img может быть false (Bool) или массивом — декодируем безопасно
            addImg = try? c.decodeIfPresent([AddImage].self, forKey: .addImg)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, slug, link, date, title, categories, acf
        case betterFeaturedImage = "better_featured_image"
    }
}
