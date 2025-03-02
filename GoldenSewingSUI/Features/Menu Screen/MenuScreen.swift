import SwiftUI

public struct MenuScreen: View {
    @Injected(\.router) private var router
    
    private var allItems = MenuItemType.allCases
    
    public var body: some View {
        ScrollView {
            ForEach(allItems) { item in
                Button {
                    switch item {
                    case .delivery:
                        router.push(.menuDelivery)
                    case .discount:
                        router.push(.menuDiscount)
                    case .awards:
                        router.push(.menuAwards)
                    case .aboutUs:
                        router.push(.menuAboutUs)
                    case .forPartners:
                        router.push(.menuForPartners)
                    case .contacts:
                        router.push(.menuContacts)
                    }
                } label: {
                    MenuItemView(item: item)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Меню")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MenuScreen()
    }
}
