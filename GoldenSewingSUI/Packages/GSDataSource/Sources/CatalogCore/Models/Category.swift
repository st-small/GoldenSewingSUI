import SQLiteData

@Table
public nonisolated struct Category: Identifiable, Hashable, Sendable {
    public let id: Int32
    public var name: String = ""
    public var slug: String = ""
    public var description: String = ""
    public var link: String = ""
    public var count: Int = 0
    public var parent: Int32 = 0
    public var priority: Int = 0
}

extension Category {
    init(from dto: CategoryJSON) {
        id = dto.id
        name = CategoryConstants.titles[dto.id] ?? dto.name
        slug = dto.slug ?? ""
        description = dto.description ?? ""
        link = dto.link ?? ""
        count = dto.count ?? 0
        parent = dto.parent ?? 0
        priority = CategoryConstants.priorities[dto.id] ?? dto.priority ?? 0
    }
}
