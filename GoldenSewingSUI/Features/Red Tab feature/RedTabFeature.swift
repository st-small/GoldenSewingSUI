import ComposableArchitecture
import SwiftUI

struct RedTabFeature: Reducer {
    struct State: Equatable { }
    enum Action: Equatable { }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { }
        }
    }
}

struct RedTabView: View {
    
    let store: StoreOf<RedTabFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.red.ignoresSafeArea()
            }
        }
    }
}
