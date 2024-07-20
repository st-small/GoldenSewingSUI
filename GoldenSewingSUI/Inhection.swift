// MARK: - Database
@MainActor
private struct DataProviderKey: InjectionKey {
    static var currentValue: DataProviderProtocol = DataProvider()
}

public extension InjectedValues {
    var dbProvider: DataProviderProtocol {
        get { Self[DataProviderKey.self] }
        set { Self[DataProviderKey.self] = newValue }
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
