import ComposableArchitecture
import SwiftUI

struct GreenTabFeature: Reducer {
    struct State: Equatable { }
    enum Action: Equatable { }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action { }
        }
    }
}

struct GreenTabView: View {
    
    let store: StoreOf<GreenTabFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.green.ignoresSafeArea()
            }
        }
    }
}
