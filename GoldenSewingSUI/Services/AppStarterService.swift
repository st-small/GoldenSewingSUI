
public struct AppStarterService {
    @Injected(\.favsObserver) private var favsObserver
    @Injected(\.dbProvider) private var dbProvider
    
    public func start() async {
        let cache = DataSource()
        let swiftData = dbProvider
        let normaliser = DataNormaliser(
            cache: cache,
            swiftData: swiftData
        )
        
        await normaliser.start()
        await favsObserver.fetchFavourites()
    }
}
