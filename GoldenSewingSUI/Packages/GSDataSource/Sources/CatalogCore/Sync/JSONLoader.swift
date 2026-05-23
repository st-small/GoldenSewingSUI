import Foundation

struct JSONLoader {
    func loadCategories() throws -> [CategoryJSON] {
        guard let url = Bundle.module.url(forResource: "categories", withExtension: "json") else {
            throw CatalogError.missingResource("categories.json")
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CategoryJSON].self, from: data)
    }

    func loadProducts() throws -> [ProductJSON] {
        let decoder = JSONDecoder()
        var all: [ProductJSON] = []
        var page = 1
        while let url = Bundle.module.url(forResource: "posts_\(page)", withExtension: "json") {
            let data = try Data(contentsOf: url)
            let products = try decoder.decode([ProductJSON].self, from: data)
            all.append(contentsOf: products)
            page += 1
        }
        guard !all.isEmpty else {
            throw CatalogError.missingResource("posts_1.json")
        }
        return all
    }
}

enum CatalogError: Error, Sendable {
    case missingResource(String)
}
