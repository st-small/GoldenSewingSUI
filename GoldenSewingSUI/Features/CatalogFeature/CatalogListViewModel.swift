import Combine
import Foundation
import ModelsKit

public final class CatalogListViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    
    @Published private(set) var categories: [CategoryModel] = []

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchData()
        
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    private func fetchData() {
        Task { @MainActor in
            categories = await dbProvider().readCategories()
        }
    }
}
