import CachedDataKit
import DataNormaliserKit
import NetworkKit
import SwiftDataProviderKit
import SwiftUI

@main
struct GoldenSewingSUIApp: App {
    @Injected(\.dbProvider) private var dbProvider
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .task {
                    let cache = DataSource()
                    let swiftData = dbProvider//DataProvider()
                    let normaliser = DataNormaliser(
                        cache: cache,
                        swiftData: swiftData
                    )
                    
                    await normaliser.start()
                }
        }
    }
}
