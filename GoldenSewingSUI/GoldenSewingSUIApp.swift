import CachedDataKit
import DataNormaliserKit
import NetworkKit
import SwiftDataProviderKit
import SwiftUI

@main
struct GoldenSewingSUIApp: App {
//    @StateObject private var categoriesManager = DataProvider()
    
    @Injected(\.dbProvider) private var dbProvider
    
    var body: some Scene {
        WindowGroup {
            CatalogListFeature()
//                .environment(categoriesManager)
                .task {
                    let cache = DataSource()
                    let swiftData = dbProvider//DataProvider()
                    let normaliser = DataNormaliser(
                        cache: cache,
                        swiftData: swiftData
                    )
                    
                    await normaliser.start()
                }
        }
    }
}

public protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}

public struct InjectedValues {
    public static var current = InjectedValues()
    
    public static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    public static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
public struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    public var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

@MainActor
private struct DataProviderKey: InjectionKey {
    static var currentValue: DataProviderProtocol = DataProvider()
}

extension InjectedValues {
    public var dbProvider: DataProviderProtocol {
        get { Self[DataProviderKey.self] }
        set { Self[DataProviderKey.self] = newValue }
    }
}
