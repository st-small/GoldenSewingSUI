import SwiftUI

public extension Color {
    init(_ hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }

    var hexa: UInt32 {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        let uic = UIColor(self)
        uic.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var value: UInt32 = 0
        value += UInt32(alpha * 255) << 24
        value += UInt32(red * 255) << 16
        value += UInt32(green * 255) << 8
        value += UInt32(blue * 255)
        return value
    }
}

