import Foundation
import SwiftUI

struct CategoryDTO: Equatable, Identifiable, Codable {
    let id: Int32
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
    }
    
    init(id: Int32, title: String) {
        self.id = id
        self.title = title
    }
    
    init(from object: Category) {
        self.id = object.id
        self.title = object.title ?? "Unexpected title"
    }
}

extension CategoryDTO {
    var image: Image {
        switch id {
        case 1:
            return Image(.otherIcon)
        case 3:
            return Image(.iconostasisIcon)
        case 4:
            return Image(.iconsIcon)
        case 5:
            return Image(.threadsIcon)
        case 6:
            return Image(.mitresIcon)
        case 7:
            return Image(.vestmentsIcon)
        case 8:
            return Image(.vestmentsIcon)
        case 9:
            return Image(.vestmentsIcon)
        case 10:
            return Image(.crestsIcon)
        case 11:
            return Image(.pokrovcyIcon)
        case 13:
            return Image(.skrizhaliIcon)
        case 101:
            return Image(.metanitIcon)
        case 103:
            return Image(.fabricIcon)
        case 141:
            return Image(.folkIcon)
        case 155:
            return Image(.saleIcon)
        case 156:
            return Image(.setsIcon)
        default:
            return Image(.otherIcon)
        }
    }
}

extension CategoryDTO {
    static let mock = Self(id: 5, title: "Mitres")
    static let mock2 = Self(id: 7, title: "Icons")
}
