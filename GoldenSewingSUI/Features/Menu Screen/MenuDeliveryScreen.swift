import SwiftUI

struct MenuDeliveryScreen: View {
    private let rows = [
        MenuItemRow(
            title: "Доставка изделий",
            elements: [
                "курьерскими службами",
                "по почте"
            ]
        ),
        MenuItemRow(
            title: "Условия доставки",
            elements: [
                "оплата за доставку осуществляется Заказчиком",
                "при индивидуальном заказе продукции на сумму свыше 5000$ бесплатная доставка по Украине и ближнему зарубежью"
            ]
        ),
        MenuItemRow(
            title: "Оплата за заказ",
            elements: [
                "изготовление индивидуальных заказов осуществляется после оплаты 50% стоимости заказа",
                "почтовым или банковским переводом (в том числе, и на расчетный счет предприятия)",
                "денежными переводами Western Union, Privat Money, Money Gram и другими"
            ]
        )
    ]
    
    var body: some View {
        if #available(iOS 18.0, *) {
            List {
                ForEach(rows) { $0 }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Доставка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        } else {
            List {
                ForEach(rows) { $0 }
            }
            .navigationTitle("Доставка")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MenuDeliveryScreen()
    }
}
