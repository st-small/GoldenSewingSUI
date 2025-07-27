import ModelsKit
import SwiftUI

public enum Route: Hashable {
    case catalogList
    case productsList(CategoryModel)
    case productDetail(ProductModel)
	case gallery(Int)
    case favouritesList
    case favouritesDetail(ProductModel)
    case menu
    case menuDelivery
    case menuDiscount
    case menuAwards
    case menuAboutUs
    case menuForPartners
    case menuContacts
}

public enum RootRouteType {
    case categories, favourites, menu
}

public final class Router<T: Hashable>: ObservableObject {
    @Published private(set) var categoriesRoot: T
    @Published private(set) var favoritesRoot: T
    @Published private(set) var menuRoot: T
    
    @Published var categoriesPaths: [T] = []
    @Published var favoritesPaths: [T] = []
    @Published var menuPaths: [T] = []
    
    @Published private(set) var selectedRouteType: RootRouteType
    
    public init(
        categoriesRoot: T,
        favoritesRoot: T,
        menuRoot: T
    ) {
        self.categoriesRoot = categoriesRoot
        self.favoritesRoot = favoritesRoot
        self.menuRoot = menuRoot
        
        selectedRouteType = .categories
    }
    
    public func didSelectTab(_ type: RootRouteType) {
        selectedRouteType = type
    }
    
    public func push(_ path: T) {
        switch selectedRouteType {
        case .categories:
            categoriesPaths.append(path)
        case .favourites:
            favoritesPaths.append(path)
        case .menu:
            menuPaths.append(path)
        }
    }
    
    public func pop() {
        switch selectedRouteType {
        case .categories:
            categoriesPaths.removeLast()
        case .favourites:
            favoritesPaths.removeLast()
        case .menu:
            menuPaths.removeLast()
        }
    }
    
    public func popToRoot() {
        switch selectedRouteType {
        case .categories:
            categoriesPaths.removeAll()
        case .favourites:
            favoritesPaths.removeAll()
        case .menu:
            menuPaths.removeAll()
        }
    }
}

public struct RouterCatalogView<T: Hashable, C: View>: View {
    @ObservedObject var router: Router<T>
    @ViewBuilder var buildView: (T) -> C
    
    public var body: some View {
        NavigationStack(path: $router.categoriesPaths) {
            buildView(router.categoriesRoot)
                .navigationDestination(for: T.self) { path in
                    buildView(path)
                }
        }
    }
}

public struct RouterFavouritesView<T: Hashable, C: View>: View {
    @ObservedObject var router: Router<T>
    @ViewBuilder var buildView: (T) -> C
    
    public var body: some View {
        NavigationStack(path: $router.favoritesPaths) {
            buildView(router.favoritesRoot)
                .navigationDestination(for: T.self) { path in
                    buildView(path)
                }
        }
    }
}

public struct RouterMenuView<T: Hashable, C: View>: View {
    @ObservedObject var router: Router<T>
    @ViewBuilder var buildView: (T) -> C
    
    public var body: some View {
        NavigationStack(path: $router.menuPaths) {
            buildView(router.menuRoot)
                .navigationDestination(for: T.self) { path in
                    buildView(path)
                }
        }
    }
}
