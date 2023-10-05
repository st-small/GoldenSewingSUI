import Dependencies
import Foundation

struct UserDefaultsClient: Sendable {
    var boolForKey: @Sendable (String) -> Bool
    var dataForKey: @Sendable (String) -> Data?
    var doubleForKey: @Sendable (String) -> Double
    var integerForKey: @Sendable (String) -> Int
    var remove: @Sendable (String) async -> Void
    var setBool: @Sendable (Bool, String) async -> Void
    var setData: @Sendable (Data?, String) async -> Void
    var setDouble: @Sendable (Double, String) async -> Void
    var setInteger: @Sendable (Int, String) async -> Void
    
    public var hasShownFirstLaunchOnboarding: Bool {
        boolForKey(hasShownFirstLaunchOnboardingKey)
    }
}

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

extension UserDefaultsClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = { UserDefaults(suiteName: "group.goldenSewing")! }
        return Self(
            boolForKey: { defaults().bool(forKey: $0) },
            dataForKey: { defaults().data(forKey: $0) },
            doubleForKey: { defaults().double(forKey: $0) },
            integerForKey: { defaults().integer(forKey: $0) },
            remove: { defaults().removeObject(forKey: $0) },
            setBool: { defaults().set($0, forKey: $1) },
            setData: { defaults().set($0, forKey: $1) },
            setDouble: { defaults().set($0, forKey: $1) },
            setInteger: { defaults().set($0, forKey: $1) }
        )
    }()
}

let hasShownFirstLaunchOnboardingKey = "hasShownFirstLaunchOnboardingKey"
