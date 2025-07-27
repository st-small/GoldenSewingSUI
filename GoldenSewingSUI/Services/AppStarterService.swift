import Dependencies

public struct AppStarterService {
	@Injected(\.favsObserver) private var favsObserver
	@Injected(\.dbProvider) private var dbProvider
	
	@Dependency(\.feature) private var feature
	
	public func start() async {
		let cache = DataSource()
		let swiftData = dbProvider
		let normaliser = DataNormaliser(
			cache: cache,
			swiftData: swiftData
		)
		
		await normaliser.start()
		await favsObserver.fetchFavourites()
		
		feature.set([
			.networkUpdatesEnabled
		], false)
	}
}
