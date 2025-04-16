import SwiftUI

struct MenuDiscountScreen: View {
    private let rows = [
        MenuItemRow(
            title: "5%",
            elements: [
                MenuRowElement(
                    value: "Православным Епархиям при заказе более 3-х изделий одного наименования.",
                    isDotted: false
                )
            ]
        ),
        MenuItemRow(
            title: "10%",
            elements: [
                MenuRowElement(
                    value: "Православным Епархиям при одновременном заказе различных изделий на сумму свыше 5 000$.",
                    isDotted: false
                )
            ]
        ),
        MenuItemRow(
            title: "от 2% до 10%",
            elements: [
                MenuRowElement(
                    value: "Своим постоянным заказчикам предприятие предоставляет накопительную скидку от 2% до 10% по следующей схеме:\n   • от 1 000$ и выше — 2%\n   • от 3 000$ и выше — 5%\n   • от 5 000$ и выше — 10%.",
                    isDotted: false
                )
            ]
        ),
    ]
    
    var body: some View {
        if #available(iOS 18.0, *) {
            List {
                ForEach(rows) { $0 }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Скидки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        } else {
            List {
                ForEach(rows) { $0 }
            }
            .navigationTitle("Скидки")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MenuDiscountScreen()
    }
}
