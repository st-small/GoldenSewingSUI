import Dependencies
import Foundation

struct APIClient: Sendable {
    var fetchCategories: @Sendable () async throws -> [CategoryDTO]
    var fetchPosts: @Sendable () async throws -> [PostDTO]
    var fetchMedia: @Sendable () async throws -> [MediaDTO]
    
    enum ClientItemType {
        case post, category, media
        
        var totalPagesURL: URL? {
            switch self {
            case .post:
                return URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/posts?per_page=100")
                
            case .category:
                return URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories?per_page=100")
                
            case .media:
                return URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/media?per_page=100")
            }
        }
    }
}

extension APIClient: DependencyKey {
    static var liveValue = Self(
        fetchCategories: {
            let categoriesCount = try await getTotalPagesCount(.category)
            var categoriesResult: [CategoryDTO] = []
            
            for page in 1...categoriesCount {
                @Dependency(\.logger) var logger
                logger.info("--- Try to load categories \(page) page ---")
                
                let url = URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/categories?page=\(page)&per_page=100")
                let request = URLRequest(url: url!)
                let (data, _) = try await URLSession.shared.data(for: request)
                categoriesResult.append(contentsOf: try JSONDecoder().decode([CategoryDTO].self, from: data))
            }
            
            return categoriesResult
        },
        fetchPosts: {
            let postsCount = try await getTotalPagesCount(.post)
            var postsResult: [PostDTO] = []
            
            for page in 1...postsCount {
                #warning("Реализовать нормальный реквест билдер!")
                @Dependency(\.logger) var logger
                logger.info("--- Try to load posts \(page) page ---")
                
                let url = URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/posts?page=\(page)&per_page=100")
                let request = URLRequest(url: url!)
                let (data, _) = try await URLSession.shared.data(for: request)
                
                postsResult.append(contentsOf: try JSONDecoder().decode([PostDTO].self, from: data))
            }
            
            return postsResult
        },
        fetchMedia: {
            let mediaCount = try await getTotalPagesCount(.media)
            var mediaResult: [MediaDTO] = []
            
            for page in 1...mediaCount {
                @Dependency(\.logger) var logger
                logger.info("--- Try to load media \(page) page ---")
                
                let url = URL(string: "https://zolotoe-shitvo.kr.ua/wp-json/wp/v2/media?page=\(page)&per_page=100")
                let request = URLRequest(url: url!)
                let (data, _) = try await URLSession.shared.data(for: request)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                mediaResult.append(contentsOf: try decoder.decode([MediaDTO].self, from: data))
            }
            
            return mediaResult
        }
    )
    
    static var testValue = Self(
        fetchCategories: { [CategoryDTO.mock] },
        fetchPosts: { [PostDTO.mock] },
        fetchMedia: { [MediaDTO.mock] }
    )
    
    static var errorValue = Self(
        fetchCategories: {
            struct APIClientError: Error, LocalizedError {
                var errorDescription: String? { "Categories API error" }
            }
            throw APIClientError()
        },
        fetchPosts: {
            struct APIClientError: Error, LocalizedError {
                var errorDescription: String? { "Posts API error" }
            }
            throw APIClientError()
        },
        fetchMedia: {
            struct APIClientError: Error, LocalizedError {
                var errorDescription: String? { "Media API error" }
            }
            throw APIClientError()
        }
    )
    
    static private func getTotalPagesCount(_ type: APIClient.ClientItemType) async throws -> Int {
        guard let url = type.totalPagesURL else { return 1 }
        
        let request = URLRequest(url: url)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        return Int(response.headerField(forKey: "X-WP-TotalPages") ?? "1") ?? 1
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
