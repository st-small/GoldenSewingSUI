import ComposableArchitecture
import SwiftUI

@main
struct GoldenSewingSUIApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    
    init() {
        #if DEBUG
        print("<<< App folder \(Bundle.main.resourceURL!)")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
            .onChange(of: scenePhase) { newValue, _ in
                store.send(.appDelegate(.scenePhaseActive))
            }
        }
    }
}
