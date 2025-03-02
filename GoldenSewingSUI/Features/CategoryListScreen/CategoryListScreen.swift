import Combine
import ModelsKit
import SwiftUI

public final class CategoryListViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    @Injected(\.favsObserver) private var favsObserver
    
    @Published private(set) var category: CategoryModel
    @Published private(set) var items: [ProductModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(_ category: CategoryModel) {
        self.category = category
        
        fetchProducts()
    }
    
    private func fetchProducts() {
        Task { @MainActor in
            do {
                items = try await dbProvider.getProducts(category.id.value)
            } catch {
                preconditionFailure(error.localizedDescription)
            }
        }
    }
}

struct CategoryListScreen: View {
    @Injected(\.router) private var router
    
    @StateObject private var vm: CategoryListViewModel
    
    public init(_ category: CategoryModel) {
        _vm = StateObject(wrappedValue: .init(category))
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.items) { product in
                    Button {
                        router.push(.productDetail(product))
                    } label: {
                        ProductItemView(product: product)
                            .frame(height: 240)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(vm.category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
