import SwiftUI

#warning("Придумать куда это все деть!!!")

extension URL {
//    static let posts = Bundle.main.url(forResource: "Posts", withExtension: "json")!
    static let posts = Bundle.main.url(forResource: "all_DB", withExtension: "json")!
    static let categories = Bundle.main.url(forResource: "Categories", withExtension: "json")!
}

extension URLResponse {
    func headerField(forKey key: String) -> String? {
        (self as? HTTPURLResponse)?.allHeaderFields[key] as? String
    }
}
