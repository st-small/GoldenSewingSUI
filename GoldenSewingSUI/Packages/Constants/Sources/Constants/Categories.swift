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
	
	public static func priority(_ id: UInt32) -> UInt8 {
		categoryPriority[id]!
	}
	
	public static func subtitle(_ id: UInt32) -> String {
		"Для церковного убранства и домашнего уюта"
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

private let categoryPriority = [
	UInt32(4) /* "Иконы" */: UInt8(160),
	UInt32(3) /*"Иконостасы" */: UInt8(150),
	UInt32(6) /* "Митры" */: UInt8(140),
	UInt32(5) /* "Вышивка для митр" */: UInt8(130),
	UInt32(7) /* "Архиерейские облачения" */: UInt8(120),
	UInt32(9) /* "Иерейские облачения" */: UInt8(110),
	UInt32(8) /* "Диаконские облачения" */: UInt8(100),
	UInt32(13) /* "Скрижали и кресты" */: UInt8(90),
	UInt32(10) /* "Плащаницы и хоругви" */: UInt8(90),
	UInt32(11) /* "Покровцы и орлецы" */: UInt8(80),
	UInt32(141) /* "Вышивка на одежде" */: UInt8(70),
	UInt32(156) /* "Венчание и крещение" */: UInt8(60),
	UInt32(0) /* "Геральдика" */: UInt8(50),
	UInt32(1) /* "Разное" */: UInt8(40),
	UInt32(155) /*"Распродажа" */: UInt8(30),
	UInt32(101) /* "Металлонить" */: UInt8(20),
	UInt32(103) /* "Церковные ткани" */: UInt8(10)
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
