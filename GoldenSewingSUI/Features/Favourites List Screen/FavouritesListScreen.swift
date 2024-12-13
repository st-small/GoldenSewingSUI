import SwiftUI

public struct FavouritesListScreen: View {
    @Injected(\.router) private var router
    
    public var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            
            Button("FavouritesListScreen") {
                router.push(.favouritesDetail)
            }
        }
    }
}
