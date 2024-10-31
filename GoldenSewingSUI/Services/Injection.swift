// MARK: - Database
private struct DataHandlerKey: InjectionKey {
    static var currentValue: @Sendable () async -> DataHandler = {
        DataProvider().dataHandleCreator()
    }()
}

public extension InjectedValues {
    var dbProvider: @Sendable () async -> DataHandler {
        get { Self[DataHandlerKey.self] }
        set { Self[DataHandlerKey.self] = newValue }
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
