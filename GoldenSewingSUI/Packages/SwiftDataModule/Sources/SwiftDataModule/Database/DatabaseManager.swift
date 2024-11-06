import ModelsKit
import SwiftData

public final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    let container: ModelContainer
    
    private init() {
        let schema = Schema(CurrentScheme.models)
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        print("Model container path: \(configuration.url)")
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: configuration
            )
        } catch {
            preconditionFailure()
        }
    }
}
