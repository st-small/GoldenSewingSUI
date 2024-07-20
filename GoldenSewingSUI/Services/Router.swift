import SwiftUI

public enum Route: Hashable {
    case catalogList, productsList
}

public final class Router<T: Hashable>: ObservableObject {
    @Published var root: T
    @Published var paths: [T] = []
    
    init(root: T) {
        self.root = root
    }
    
    public func push(_ path: T) {
        paths.append(path)
    }
    
    public func pop() { 
        paths.removeLast()
    }
    
    public func pop(to: T) { 
        guard let found = paths.firstIndex(where: { $0 == to }) else { return }
        let numPop = (found ..< paths.endIndex).count - 1
        paths.removeLast(numPop)
    }
    
    public func popToRoot() { 
        paths.removeAll()
    }
}

public struct RouterView<T: Hashable, C: View>: View {
    @ObservedObject var router: Router<T>
    @ViewBuilder var buildView: (T) -> C
    
    public var body: some View {
        NavigationStack(path: $router.paths) {
            buildView(router.root)
                .navigationDestination(for: T.self) { path in
                    buildView(path)
                }
        }
    }
}
