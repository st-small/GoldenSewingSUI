import SwiftUI

struct MenuForPartnersScreen: View {
    private let rows = [
        MenuItemRow(
            title: "Закупаем канитель",
            elements: [
                MenuRowElement(
                    value: "золотую - все виды: с 3% и 5% содержанием золота"),
                MenuRowElement(
                    value: "серебрянную (блестящую и матовую)"),
                MenuRowElement(
                    value: "трунцал золоченный, серебрянный"),
                MenuRowElement(
                    value: "жесткая канитель-проволка"),
                MenuRowElement(
                    value: "все виды цветной канители.")
            ]
        ),
        MenuItemRow(
            title: "Закупаем натуральные камни",
            elements: [
                MenuRowElement(
                    value: "Рассмотрим предложения фирм и частных лиц по закупке шлифованных натуральных камней (гранат, оникс, топаз, бирюза, жемчуг, аметист и др.) следующих диаметров:\n   • малые (Ø от 1,5мм до 2,5мм)\n   • средние (Ø от 2,5мм до 4,5мм)\n   • крупные (Ø от 4,5мм до 6,5мм).",
                    isDotted: false
                )
            ]
        ),
        MenuItemRow(
            title: "Для православных магазинов",
            elements: [
                MenuRowElement(
                    value: "Предлагаем комплекты вышивки для сбора митр, покровцы, кресты, плащаницы и другие товары по специальным ценам.",
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
            .navigationTitle("Партнерам")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        } else {
            List {
                ForEach(rows) { $0 }
            }
            .navigationTitle("Партнерам")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MenuForPartnersScreen()
    }
}
