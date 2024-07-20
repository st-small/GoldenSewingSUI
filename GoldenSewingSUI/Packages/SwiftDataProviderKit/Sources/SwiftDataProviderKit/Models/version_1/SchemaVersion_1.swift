import Foundation
import SwiftData

public typealias CurrentScheme = SchemaVersion_1

public enum SchemaVersion_1: VersionedSchema {
    public static var versionIdentifier: Schema.Version {
        .init(1, 0, 0)
    }
    
    public static var models: [any PersistentModel.Type] {
        [SDCategoryModel.self]
    }
}
