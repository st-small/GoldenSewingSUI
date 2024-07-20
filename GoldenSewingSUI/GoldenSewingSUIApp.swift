import SwiftUI

@main
struct GoldenSewingSUIApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    private let starterService = AppStarterService()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .onChange(of: scenePhase) { _, newPhase in
                    guard case newPhase = .active else { return }
                    Task { await starterService.start() }
                }
        }
    }
}
