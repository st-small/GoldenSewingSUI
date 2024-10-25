import Combine
import ModelsKit
import SwiftUI

public final class CategoryListViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    
    @Published private(set) var category: CategoryModel!
    @Published private(set) var items: [PostModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(_ categoryID: CategoryID) {
        category = dbProvider.categories.first(where: { $0.id == categoryID })!
        
        dbProvider.postsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] posts in
                items = posts.filter { $0.categories.contains(category) }
            }
            .store(in: &cancellables)
    }
}

struct CategoryListScreen: View {
    let categoryID: CategoryID
    
    @StateObject private var vm: CategoryListViewModel
    
    public init(_ categoryID: CategoryID) {
        self.categoryID = categoryID
        _vm = StateObject(wrappedValue: .init(categoryID))
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.items) {
                    ProductItemView(product: $0)
                        .frame(height: 240)
                        .border(.green)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(vm.category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
