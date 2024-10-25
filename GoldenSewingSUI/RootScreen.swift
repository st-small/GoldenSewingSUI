import SwiftUI

struct RootScreen: View {
    @Injected(\.router) private var router
    
    var body: some View {
        RouterView(router: router) { path in
            switch path {
            case .catalogList:
                CatalogListFeature()
            case let .productsList(categoryID):
                CategoryListScreen(categoryID)
            case let .productDetail(product):
                PostDetailScreen(post: product)
            }
        }
    }
}

#Preview {
    RootScreen()
}
