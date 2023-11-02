import Foundation

extension Dictionary where Key == String, Value == String {
    var rendered: String {
        guard let renderedValue = self["rendered"] else { return "" }

        var result = renderedValue.replacingOccurrences(of: "&#171;", with: "\"")
        result = result.replacingOccurrences(of: "&#187;", with: "\"")
        
        return result
    }
}
