import ModelsKit
import NetworkKit
import SwiftUI

public enum ImageLoaderError: LocalizedError {
    case imageDamaged
    
    public var errorDescription: String? {
        switch self {
        case .imageDamaged:
            return "Файл поврежден"
        }
    }
}

public actor ImageLoader {
    @Injected(\.dbProvider) private var dbProvider
    
    private enum LoaderStatus {
        case inProgress(Task<Data, Error>)
        case complete(Data)
    }
    
    private var images: [ImageID: LoaderStatus] = [:]
    
    private let network = NetworkService()
    
    public func getImage(
        _ model: ImageModel,
        width: CGFloat,
        height: CGFloat
    ) async throws -> UIImage {
        do {
            let imageData = try await fetch(model)
            guard let uiImage = UIImage(data: imageData) else {
                throw ImageLoaderError.imageDamaged
            }
            
            return uiImage.resize(width, height)
        } catch {
            throw error
        }
    }
    
    public func getFullImage(_ model: ImageModel) async throws -> UIImage {
        do {
            let imageData = try await fetch(model)
            guard let uiImage = UIImage(data: imageData) else {
                throw ImageLoaderError.imageDamaged
            }
            
            return uiImage
        } catch {
            throw error
        }
    }
    
    private func fetch(_ model: ImageModel) async throws -> Data {
        if let status = images[model.id] {
            switch status {
            case let .inProgress(task):
                return try await task.value
            case let .complete(data):
                return data
            }
        }
        
        if let imageData = await readFromDatabase(model) {
            images[model.id] = .complete(imageData)
            return imageData
        }
        
        let task: Task<Data, Error> = Task {
            let imageData = try await network.downloadImage(model.link)
            await storeInDatabase(model.id.value, data: imageData)
            return imageData
        }
        
        images[model.id] = .inProgress(task)
        
        let image = try await task.value
        images[model.id] = .complete(image)
        
        return image
    }
    
    private func readFromDatabase(_ model: ImageModel) async -> Data? {
        do {
            return try await dbProvider.getImage(model.id.value).image
        } catch {
            print("Error \(error.localizedDescription)")
            preconditionFailure()
        }
    }
    
    private func storeInDatabase(_ id: UInt32, data: Data) async {
        do {
            try await dbProvider.addImage(id, data: data)
        } catch {
            print("Error \(error.localizedDescription)")
            preconditionFailure()
        }
    }
}
