import Dependencies
import Foundation

public struct FeatureFlags: OptionSet, Codable, Sendable {
	public let rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	// Define your features here
	public static let networkUpdatesEnabled = FeatureFlags(rawValue: 1 << 0)
	
	// Common combinations if needed
	public static let defaultFlags: FeatureFlags = []
}

@propertyWrapper
public struct FeatureFlag {
	@Dependency(\.feature) private var feature
	let flag: FeatureFlags
	
	public var wrappedValue: Bool {
		get { feature.isEnabled(flag) }
		set { feature.set(flag, newValue) }
	}
}

public struct FeatureManager: Sendable {
	public var isEnabled: @Sendable (FeatureFlags) -> Bool
	public var set: @Sendable (FeatureFlags, Bool) -> Void
	public var reset: @Sendable () -> Void
}

public final class Defaults: Sendable {
	nonisolated(unsafe) private let defaults: UserDefaults
	
	public init(defaults: UserDefaults) {
		self.defaults = defaults
	}
}

extension FeatureManager: DependencyKey {
	public static var liveValue: FeatureManager {
		let defaults = UserDefaults.standard
		let key = "com.goldensewing.featureflags"
		
		nonisolated(unsafe) var enabledFlags: FeatureFlags {
			get {
				guard let rawValue = defaults.object(forKey: key) as? Int else {
					return FeatureFlags.defaultFlags
				}
				return FeatureFlags(rawValue: rawValue)
			}
			set {
				defaults.set(newValue.rawValue, forKey: key)
			}
		}
		
		return Self(
			isEnabled: { flag in
				enabledFlags.contains(flag)
			},
			set: { flag, isEnabled in
				switch isEnabled {
				case true:
					enabledFlags.insert(flag)
				case false:
					enabledFlags.remove(flag)
				}
			},
			reset: {
				enabledFlags = .defaultFlags
			}
		)
	}
	
	public static var testValue: FeatureManager {
		let defaults = UserDefaults.standard
		let key = "com.goldensewing.featureflags.test"
		
		return Self(
			isEnabled: { _ in fatalError() },
			set: { _,_ in fatalError() },
			reset: { fatalError() }
		)
	}
}

public extension DependencyValues {
	var feature: FeatureManager {
		get { self[FeatureManager.self] }
		set { self[FeatureManager.self] = newValue }
	}
}
