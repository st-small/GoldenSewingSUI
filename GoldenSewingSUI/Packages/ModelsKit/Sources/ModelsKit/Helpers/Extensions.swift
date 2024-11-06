import Foundation

extension String {
    var htmlDecoded: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let decoded = try? NSAttributedString(
            data: encodedData,
            options: attributedOptions,
            documentAttributes: nil
        )
        
        return decoded?.string ?? self
    }
}
