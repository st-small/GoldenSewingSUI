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
    static var currentValue: Router<Route> = Router(root: .catalogList)
}


extension InjectedValues {
    public var router: Router<Route> {
        get { Self[RouterInjectionKey.self] }
        set { Self[RouterInjectionKey.self] = newValue }
    }
}


extension EnvironmentValues {
    @Entry var imageLoader = ImageLoader()
}
