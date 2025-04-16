import Combine
import SwiftUI

public struct TabItemModel: Identifiable, Equatable, Hashable {
    public var id: String { title }
    let icon: Image
    let title: String
    
    static let home = TabItemModel(
        icon: Image(.home),
        title: "Главная"
    )
    
    static let catalog = TabItemModel(
        icon: Image(.catalog),
        title: "Каталог"
    )
    
    static let favs = TabItemModel(
        icon: Image(.favs),
        title: "Избранное"
    )
    
    static let menu = TabItemModel(
        icon: Image(.menu),
        title: "Меню"
    )
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

public final class GSTabViewModel: ObservableObject {
    @Injected(\.router) private var router
    
    @Published var selectedTab: TabItemModel = .catalog
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init() {
        router.$selectedRouteType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selected in
                switch selected {
                case .categories:
                    self?.didSelectTab(.catalog)
                case .favourites:
                    self?.didSelectTab(.favs)
                case .menu:
                    self?.didSelectTab(.menu)
                }
            }
            .store(in: &cancellables)
    }
    
    public func didSelectTab(_ tag: TabItemModel) {
        selectedTab = tag
        
        switch selectedTab {
        case .catalog:
            router.didSelectTab(.categories)
        case .favs:
            router.didSelectTab(.favourites)
        case .menu:
            router.didSelectTab(.menu)
        default:
            fatalError()
        }
    }
}

public struct GSTabView: View {
    @Injected(\.router) private var router
    
    @StateObject private var vm = GSTabViewModel()
    
    private var bottomItems: [TabItemModel] {
        [.catalog, .favs, .menu]
    }
    
    public var body: some View {
        BottomBar(
            selectedTab: Binding(
                get: { vm.selectedTab },
                set: { vm.didSelectTab($0) }
            ),
            items: bottomItems
        ) {
            RouterCatalogView(router: router) { path in
                switch path {
                case .catalogList:
                    CatalogListFeature()
                case let .productsList(category):
                    CategoryListScreen(category)
                case let .productDetail(product):
                    ProductDetailScreen(product)
                default:
                    Text("RouterCatalogView: No view!")
                }
            }
            .tag(TabItemModel.catalog)
            
            RouterFavouritesView(router: router) {
                path in
                switch path {
                case .favouritesList:
                    FavouritesListScreen()
                case let .favouritesDetail(product):
                    ProductDetailScreen(product)
                default:
                    Text("RouterFavouritesView: No view!")
                }
            }
            .tag(TabItemModel.favs)
            
            RouterMenuView(router: router) { path in
                switch path {
                case .menu:
                    MenuScreen()
                case .menuDelivery:
                    MenuDeliveryScreen()
                case .menuDiscount:
                    MenuDiscountScreen()
                case .menuAwards:
                    MenuAwardsScreen()
                case .menuAboutUs:
                    MenuAboutUsScreen()
                case .menuForPartners:
                    MenuForPartnersScreen()
                case .menuContacts:
                    MenuContactsScreen()
                default:
                    Text("RouterMenuView: No view!")
                }
            }
            .tag(TabItemModel.menu)
        }
        .ignoresSafeArea(.keyboard)
    }
}

public struct BottomBar<Content: View>: View {
    @Binding var selectedTab: TabItemModel
    let items: [TabItemModel]
    let content: Content
    
    public init(
        selectedTab: Binding<TabItemModel>,
        items: [TabItemModel],
        @ViewBuilder content: () -> Content
    ) {
        _selectedTab = selectedTab
        self.items = items
        self.content = content()
        
        UITabBar.appearance().isHidden = true
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                content
                    .edgesIgnoringSafeArea(.all)
            }
            .tabViewStyle(.automatic)
            
            VStack(spacing: 0) {
                Divider()
                TabBarItemsView(
                    selectedTab: $selectedTab,
                    items: items
                )
            }
        }
    }
}

public struct TabBarItemsView: View {
    @Binding var selectedTab: TabItemModel
    let items: [TabItemModel]
    
    public var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            ForEach(items) { tabItem in
                BottomTabView(
                    type: tabItem,
                    isSelected: $selectedTab.toBooleanBinding(tabItem)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 5)
    }
}

public struct BottomTabView: View {
    let type: TabItemModel
    @Binding var isSelected: Bool
    
    public var body: some View {
        Button {
            withAnimation {
                isSelected.toggle()
            }
        } label: {
            VStack(spacing: 0) {
                type.icon
                Text(type.title)
                    .font(.system(size: 10, weight: .medium))
            }
        }
        .foregroundStyle(
            isSelected
            ? .black
            : Color(0x3C3C43).opacity(0.6)
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GSTabView()
}

extension Binding where Value == TabItemModel {
    func toBooleanBinding(_ selectedTab: TabItemModel) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                wrappedValue == selectedTab
            },
            set: { value in
                if value {
                    wrappedValue = selectedTab
                }
            }
        )
    }
}
