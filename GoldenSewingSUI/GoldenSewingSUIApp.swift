import ComposableArchitecture
import SwiftUI

@main
struct GoldenSewingSUIApp: App {
    
    init() {
        #if DEBUG
        print("<<< App folder \(Bundle.main.resourceURL!)")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppFeatureView(
                store: Store(
                    initialState: AppFeature.State()
                ) { AppFeature() }
            )
        }
    }
}
