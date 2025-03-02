import Combine
import ModelsKit
import SwiftUI

public final class FavouritesListViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    @Injected(\.favsObserver) private var favsObserver
    
    @Published private(set) var products: [ProductModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init() {        
        Task { @MainActor in
            await favsObserver.$favourites
                .receive(on: DispatchQueue.main)
                .sink { [weak self] favourites in
                    self?.products = favourites
                }
                .store(in: &cancellables)
        }
    }
    
    public func updateProduct(_ product: ProductModel) async {
        await favsObserver.updateProduct(product)
    }
}

public struct FavouritesListScreen: View {
    @Injected(\.router) private var router
    
    @StateObject private var vm = FavouritesListViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    public var body: some View {
        content
        .navigationTitle("Избранное")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var content: some View {
        if vm.products.isEmpty {
            emptyListView
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(vm.products) { product in
                        Button {
                            router.push(.productDetail(product))
                        } label: {
                            ProductItemView(product: product)
                                .frame(height: 240)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var emptyListView: some View {
        VStack(alignment: .center, spacing: 3) {
            Text("В избранном пусто")
                .font(.system(size: 17, weight: .semibold))
            
            (
                Text("Добавляйте товары, нажав на ")
                    .font(.system(size: 15))
                +
                Text(Image(systemName: "heart.fill"))
            )
            .foregroundStyle(Color(0x8E8E93))
            
            Button {
                withAnimation {
                    router.didSelectTab(.categories)
                    router.popToRoot()
                }
            } label: {
                Text("Перейти в каталог")
                    .foregroundStyle(Color(0x871A1A))
                    .font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 23)
                    .padding(.vertical, 13)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(0x871A1A), lineWidth: 1)
                    }
            }
            .padding(.top, 16)
        }
    }
}

#Preview {
    NavigationStack {
        FavouritesListScreen()
    }
}
