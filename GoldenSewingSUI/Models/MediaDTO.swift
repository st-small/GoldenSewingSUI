import Foundation

struct MediaDTO: Equatable, Decodable { 
    let id: Int32
    let sourceUrl: URL?
}

extension MediaDTO {
    static let mock = MediaDTO(
        id: 5,
        sourceUrl: URL(string: "https://picsum.photos/200")!
    )
}
