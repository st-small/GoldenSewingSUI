import ModelsKit
import SwiftData

@ModelActor
public actor DataHandler {
    @MainActor
    public init(container: ModelContainer) {
        let modelContext = container.mainContext
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = container
    }
    
    public func addCategories(_ categories: [CategoryModel]) {
        categories
            .map { SDCategoryModel($0) }
            .forEach {
                modelContext.insert($0)
            }
        save()
    }
    
    public func readCategories() -> [CategoryModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<SDCategoryModel>())
                .map { $0.map() }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
    public func updateCategory() throws { }
    
    public func addProduct() throws { }
    public func updateProduct() throws { }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}
