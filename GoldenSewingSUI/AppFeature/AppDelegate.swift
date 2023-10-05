import ComposableArchitecture
import Foundation

struct AppDelegateReducer: Reducer {
    struct State: Equatable { }
    enum Action: Equatable {
        case scenePhaseActive
        // case didRegisterForRemoteNotifications
        // case userNotifications
        // ... etc
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .scenePhaseActive:
                // Вот тут и запускать логику старта приложения и всех сервисов
                
                return .none
            }
        }
    }
}
