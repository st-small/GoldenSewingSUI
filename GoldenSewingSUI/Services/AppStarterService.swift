
public struct AppStarterService {
    
    @Injected(\.dbProvider) private var dbProvider
    
    public func start() async {
        let cache = DataSource()
        let swiftData = await dbProvider()
        let normaliser = DataNormaliser(
            cache: cache,
            swiftData: swiftData
        )
        
        await normaliser.start()
    }
}
