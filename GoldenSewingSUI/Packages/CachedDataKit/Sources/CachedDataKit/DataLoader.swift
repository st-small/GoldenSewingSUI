import Foundation

public final class DataLoader {
    public static func loadData(
        from: Resource,
        handler: @escaping Handler<Data, CachedDataKitError>
    ) {
        guard let resourceFile = Bundle.module.url(
            forResource: from.filename,
            withExtension: "json"
        ) else {
            handler(.failure(.categoriesDataFileMissing))
            return
        }
        
        do {
            let data = try Data(contentsOf: resourceFile)
            handler(.success(data))
        } catch {
            handler(.failure(.categoriesDataFileMissing))
        }
    }
}
