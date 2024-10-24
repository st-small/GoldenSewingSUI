import SwiftUI
import Foundation

public struct Category {
    // Custom title by category id
    public static func title(_ id: UInt32) -> String {
        categoryTitles[id]!
    }
    
    // Custom preview by category id
    public static func preview(_ id: UInt32) -> Image {
        let unwrappedID = id == 8 || id == 9 ? 7 : id
        return Image(packageResource: "category_\(unwrappedID)", ofType: "jpg")
    }
}

private let categoryTitles = [
    UInt32(0): "Геральдика",
    UInt32(1): "Разное",
    UInt32(3): "Иконостасы",
    UInt32(4): "Иконы",
    UInt32(5): "Вышивка для митр",
    UInt32(6): "Митры",
    UInt32(7): "Архиерейские облачения",
    UInt32(8): "Диаконские облачения",
    UInt32(9): "Иерейские облачения",
    UInt32(10): "Плащаницы и хоругви",
    UInt32(11): "Покровцы и орлецы",
    UInt32(13): "Скрижали и кресты",
    UInt32(101): "Металлонить",
    UInt32(103): "Церковные ткани",
    UInt32(141): "Вышивка на одежде",
    UInt32(155): "Распродажа",
    UInt32(156): "Венчание и крещение"
]

// TODO: Вынести это в отдельный пакет с расширениями и утилитами
extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}
