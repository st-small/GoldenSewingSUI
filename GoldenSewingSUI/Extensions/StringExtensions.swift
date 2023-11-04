import CryptoKit
import Foundation

extension String {
    func date(format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}

extension String {
    var md5: String {
        Insecure.MD5.hash(data: Data(self.utf8))
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
