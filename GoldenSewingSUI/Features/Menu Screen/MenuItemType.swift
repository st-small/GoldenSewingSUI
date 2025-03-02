import SwiftUI

public enum MenuItemType: String, CaseIterable, Identifiable {
    public var id: String { self.rawValue }
    
    case delivery, discount, awards, aboutUs, forPartners, contacts
    
    var title: String {
        switch self {
        case .delivery:
            "Доставка"
        case .discount:
            "Скидки"
        case .awards:
            "Награды"
        case .aboutUs:
            "О нас"
        case .forPartners:
            "Партнерам"
        case .contacts:
            "Контакты"
        }
    }
    
    var icon: Image {
        switch self {
        case .delivery:
            Image(.menuDelivery)
        case .discount:
            Image(.menuDiscount)
        case .awards:
            Image(.menuAwards)
        case .aboutUs:
            Image(.menuAbout)
        case .forPartners:
            Image(.menuPartners)
        case .contacts:
            Image(.menuContacts)
        }
    }
}
