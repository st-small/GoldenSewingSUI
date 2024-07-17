import ComposableArchitecture
import XCTest

@testable import GoldenSewingSUI

@MainActor
final class FavouritesListTests: XCTestCase {

    func test_feature_list_observing() async {
        let store = TestStore(initialState: FavouritesFeature.State()) {
            FavouritesFeature()
        } withDependencies: {
            $0.coreData = .testValue
        }
        
        await store.send(.onAppear)
        await store.send(.addFavourite(.mock)) {
            $0.favourites = [.mock]
        }
        await store.send(.onDisappear)
    }
}
