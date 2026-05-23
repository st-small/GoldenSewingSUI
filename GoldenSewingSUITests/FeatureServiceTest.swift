import Dependencies
@testable import GoldenSewingSUI
import Testing

struct Mock {
    @Dependency(\.feature) var feature

    func getFeature() -> Bool {
        return feature.isEnabled(.networkUpdatesEnabled)
    }
}

struct FeatureServiceTest {
    init() {
        withDependencies {
            $0.feature = .testValue
        } operation: {}
    }

    @Test func foo() async throws {
        let sut = Mock()

        withDependencies { _ in
            //			$0.feature.isEnabled = { _ in
            //				false
            //			}
        } operation: {
            #expect(sut.getFeature() == true)
        }
    }
}
