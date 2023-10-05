import Foundation

struct PostDTO: Equatable, Codable, Identifiable {
    let id: Int32
    
    init(id: Int32) {
        self.id = id
    }
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int32.self, forKey: .id)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    
    init(from object: Post) {
        self.id = object.id
    }
}

extension PostDTO {
    static let mock = PostDTO(id: 777)
}
