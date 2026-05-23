import Foundation

// WordPress REST API /wp/v2/categories формат.
// Лишние поля (_links, meta, acf, taxonomy) игнорируются автоматически.
struct CategoryJSON: Decodable {
    let id: Int32
    let name: String
    let slug: String?
    let description: String?
    let link: String?
    let count: Int?
    let parent: Int32?
    // Кастомное поле приоритета отображения (добавляется вручную в JSON)
    let priority: Int?
}
