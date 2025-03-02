import SwiftUI

// MARK: - Database
private struct DatabaseKey: InjectionKey {
    static var currentValue: DatabaseQueryProtocol = DatabaseQuery()
}

public extension InjectedValues {
    var dbProvider: DatabaseQueryProtocol {
        get { Self[DatabaseKey.self] }
        set { Self[DatabaseKey.self] = newValue }
    }
}

// MARK: - Router
private struct RouterInjectionKey: InjectionKey {
    static var currentValue: Router<Route> = Router(
        categoriesRoot: .catalogList,
        favoritesRoot: .favouritesList,
        menuRoot: .menu
    )
}

extension InjectedValues {
    public var router: Router<Route> {
        get { Self[RouterInjectionKey.self] }
        set { Self[RouterInjectionKey.self] = newValue }
    }
}

// MARK: - Favourites observer
private struct FavouritesObserverInjectionKey: InjectionKey {
    static var currentValue: FavouritesObserver = .init()
}

extension InjectedValues {
    public var favsObserver: FavouritesObserver {
        get { Self[FavouritesObserverInjectionKey.self] }
        set { Self[FavouritesObserverInjectionKey.self] = newValue }
    }
}

extension EnvironmentValues {
    @Entry var imageLoader = ImageLoader()
}
