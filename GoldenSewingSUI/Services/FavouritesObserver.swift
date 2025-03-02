import Combine
import ModelsKit

public actor FavouritesObserver: Sendable {
    @Injected(\.dbProvider) private var dbProvider

    @Published private(set) var favourites: [ProductModel] = []
    
    public func fetchFavourites() async {
        do {
            favourites = try await dbProvider.getFavsProducts()
        } catch {
            favourites = []
            fatalError(error.localizedDescription)
        }
    }
    
    public func updateProduct(_ product: ProductModel) {
        if let idx = favourites.firstIndex(where: { $0.id == product.id }) {
            favourites.remove(at: idx)
            print("<<< favs product remove")
            
            cacheFavouriteProduct(product.id, isFavourite: false)
        } else {
            var mutableProduct = product
            mutableProduct.isFavourite = true
            favourites.append(mutableProduct)
            print("<<< favs product append")
            
            cacheFavouriteProduct(product.id, isFavourite: true)
        }
    }
    
    private func cacheFavouriteProduct(_ id: ProductID, isFavourite: Bool) {
        Task {
            do {
                try await dbProvider.updateProduct(id.value, isFavourite: isFavourite)
            } catch {
                fatalError()
            }
        }
    }
}
