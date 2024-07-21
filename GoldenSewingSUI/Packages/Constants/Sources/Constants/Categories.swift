import SwiftUI
import Foundation

public struct Category {
    // Custom title by category id
    public static func title(_ id: Int32) -> String {
        categoryTitles[id]!
    }
    
    // Custom preview by category id
    public static func preview(_ id: Int32) -> Image {
        let unwrappedID = id == 8 || id == 9 ? 7 : id
        return Image(packageResource: "category_\(unwrappedID)", ofType: "jpg")
    }
}

private let categoryTitles = [
    Int32(0): "Геральдика",
    Int32(1): "Разное",
    Int32(3): "Иконостасы",
    Int32(4): "Иконы",
    Int32(5): "Вышивка для митр",
    Int32(6): "Митры",
    Int32(7): "Архиерейские облачения",
    Int32(8): "Диаконские облачения",
    Int32(9): "Иерейские облачения",
    Int32(10): "Плащаницы и хоругви",
    Int32(11): "Покровцы и орлецы",
    Int32(13): "Скрижали и кресты",
    Int32(101): "Металлонить",
    Int32(103): "Церковные ткани",
    Int32(141): "Вышивка на одежде",
    Int32(155): "Распродажа",
    Int32(156): "Венчание и крещение"
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
