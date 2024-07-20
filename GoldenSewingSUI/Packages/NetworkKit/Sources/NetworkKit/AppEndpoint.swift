import Foundation

public enum AppEndpoint {
    case getCategories(perPage: Int = 100)
    case getPosts
    case getMediaItems
}

extension AppEndpoint: EndPoint {
    public var host: String { "zolotoe-shitvo.kr.ua" }
    public var scheme: String { "https" }
    public var path: String {
        let prefix = "/wp-json/wp/v2"
        switch self {
        case .getCategories:
            return "\(prefix)/categories"
        case .getPosts:
            return "\(prefix)/posts"
        case .getMediaItems:
            return "\(prefix)/media"
        }
    }
    
    public var method: RequestMethod {
        switch self {
        case .getCategories, .getPosts, .getMediaItems:
            return .get
        }
    }
    
    public var header: [String : String]? { nil }
    public var body: [String : String]? { nil }
    public var queryParams: [String : String]? {
        switch self {
        case let .getCategories(perPage):
            return ["per_page": "\(perPage)"]
        case .getPosts, .getMediaItems:
            return nil
        }
    }
    public var pathParams: [String : String]? { nil }
}
