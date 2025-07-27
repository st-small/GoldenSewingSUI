
import XCTest
@testable import GoldenSewingSUI

final class FeatureFlagManagerTests: XCTestCase {
    var manager: GSFeatureFlagManager!
    var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a unique suite name for testing to avoid affecting real app's UserDefaults
        defaults = UserDefaults(suiteName: #file)!
        defaults.removePersistentDomain(forName: #file)
        
        // Create new instance for each test
        manager = GSFeatureFlagManager.shared
    }
    
    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        defaults = nil
        manager = nil
        super.tearDown()
    }
    
    func testFeatureFlagDefaultValues() {
        // When app starts, all flags should be disabled by default
        XCTAssertFalse(manager.isEnabled(.newUIEnabled))
        XCTAssertFalse(manager.isEnabled(.betaFeatures))
        XCTAssertFalse(manager.isEnabled(.debugMode))
    }
    
    func testEnablingFeatureFlag() {
        // Given
        XCTAssertFalse(manager.isEnabled(.newUIEnabled))
        
        // When
        manager.set(.newUIEnabled, enabled: true)
        
        // Then
        XCTAssertTrue(manager.isEnabled(.newUIEnabled))
    }
    
    func testDisablingFeatureFlag() {
        // Given
        manager.set(.newUIEnabled, enabled: true)
        XCTAssertTrue(manager.isEnabled(.newUIEnabled))
        
        // When
        manager.set(.newUIEnabled, enabled: false)
        
        // Then
        XCTAssertFalse(manager.isEnabled(.newUIEnabled))
    }
    
    func testMultipleFlags() {
        // Enable multiple flags
        manager.set(.newUIEnabled, enabled: true)
        manager.set(.betaFeatures, enabled: true)
        
        // Verify both are enabled
        XCTAssertTrue(manager.isEnabled(.newUIEnabled))
        XCTAssertTrue(manager.isEnabled(.betaFeatures))
        XCTAssertFalse(manager.isEnabled(.debugMode))
    }
    
    func testResettingFlags() {
        // Given
        manager.set(.newUIEnabled, enabled: true)
        manager.set(.betaFeatures, enabled: true)
        XCTAssertTrue(manager.isEnabled(.newUIEnabled))
        XCTAssertTrue(manager.isEnabled(.betaFeatures))
        
        // When
        manager.reset()
        
        // Then
        XCTAssertFalse(manager.isEnabled(.newUIEnabled))
        XCTAssertFalse(manager.isEnabled(.betaFeatures))
    }
    
    func testPersistence() {
        // Enable a flag
        manager.set(.newUIEnabled, enabled: true)
        
        // Create a new manager instance to verify persistence
        let newManager = GSFeatureFlagManager.shared
        XCTAssertTrue(newManager.isEnabled(.newUIEnabled))
    }
    
    func testPropertyWrapper() {
        final class TestClass {
            @GSFeatureFlag(flag: .newUIEnabled) var isNewUIEnabled
        }
        
        let testObject = TestClass()
        
        // Should be false by default
        XCTAssertFalse(testObject.isNewUIEnabled)
        
        // Enable the flag
        testObject.isNewUIEnabled = true
        XCTAssertTrue(testObject.isNewUIEnabled)
        
        // Verify the manager was updated
        XCTAssertTrue(manager.isEnabled(.newUIEnabled))
    }
}
