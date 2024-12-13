import SwiftUI

struct RootScreen: View {
    @Injected(\.router) private var router
    
    var body: some View {
        // TODO: Add intro or main flow paths here
        GSTabView()
    }
}

#Preview {
    RootScreen()
}
