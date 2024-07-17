import Combine
import Foundation
import ModelsKit

public final class CatalogListViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    
    @Published var categories: [CategoryModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        dbProvider.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
}
