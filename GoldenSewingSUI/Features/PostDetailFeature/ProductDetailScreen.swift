import ModelsKit
import MessageUI
import SwiftUI
import Utilities

public final class ProductDetailViewModel: ObservableObject {
    @Injected(\.dbProvider) private var dbProvider
    @Injected(\.favsObserver) private var favsObserver
    
    @Published private(set) var isFavourite: Bool = false
    
    let product: ProductModel
    
    public init(_ product: ProductModel) {
        self.product = product
        
        Task { @MainActor [favsObserver] in
            isFavourite = await favsObserver.favourites.contains(where: { $0.id == product.id })
        }
    }
    
    public func toggleProductFavourite() {
        Task {
            await favsObserver.updateProduct(product)
        }
        
        isFavourite.toggle()
    }
}

public struct ProductDetailScreen: View {
    @StateObject private var vm: ProductDetailViewModel
    
    @State private var showMailView: Bool = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var alertMessage: String?
    @State private var alertIsPresented: Bool = false
    
    public init(_ product: ProductModel) {
        _vm = StateObject(wrappedValue: .init(product))
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                ProductPreviewGalleryView(vm.product.images)
                
                HStack {
                    Text(vm.product.title)
                        .padding(.top, 30)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                VStack(spacing: 10) {
                    ProductPropertiesView(
                        type: "Артикул",
                        value: "\(vm.product.id.value)"
                    )
                    
                    ForEach(0..<vm.product.attributes.count, id: \.self) { index in
                        ProductPropertiesView(
                            type: vm.product.attributes[index].name,
                            value: vm.product.attributes[index].value.joined(separator: ", "),
                            isDivided: index != vm.product.attributes.count - 1
                        )
                    }
                }
                .padding(.top, 16)
                
                Button {
                    withAnimation {
                        showMailView.toggle()
                    }
                } label: {
                    Text("Заказать информацию")
                        .font(.system(size: 13))
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(0x871A1A))
                        )
                }
                .disabled(!MailView.canSendMail())
                .opacity(MailView.canSendMail() ? 1 : 0.4)
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
        }
        .padding([.top, .bottom], 16)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(vm.product.title)
                    .multilineTextAlignment(.center)
                    .font(.headline)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.toggleProductFavourite()
                } label: {
                    Image(systemName: vm.isFavourite
                          ? "heart.fill"
                          : "heart"
                    )
                    .foregroundStyle(
                        vm.isFavourite
                        ? Color(0x871A1A)
                        : .black
                    )
                    .frame(width: 22, height: 22)
                }
            }
        }
        .sheet(isPresented: $showMailView) {
            MailView(
                product: vm.product,
                showMail: $showMailView,
                result: $mailResult
            )
            .onDisappear {
                onMailResult()
            }
        }
        .alert(isPresented: $alertIsPresented) {
            Alert(
                title: Text("Статус отправки"),
                message: Text(alertMessage!),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func onMailResult() {
        if let mailResult {
            switch mailResult {
            case let .success(success):
                switch success {
                case .cancelled:
                    alertMessage = "Отправка отменена пользователем"
                case .saved:
                    alertMessage = "Сохранено как черновик"
                case .sent:
                    alertMessage = "Письмо отправлено успешно"
                case .failed:
                    alertMessage = "Ошибка отправки"
                @unknown default:
                    alertMessage = "Неизвестная ошибка"
                }
                
                alertIsPresented = true
            case let .failure(error):
                alertMessage = error.localizedDescription
                alertIsPresented = true
            }
        }
    }
}

struct ProductPropertiesView: View {
    let type: String
    let value: String
    let isDivided: Bool
    
    init(
        type: String,
        value: String,
        isDivided: Bool = true
    ) {
        self.type = type
        self.value = value
        self.isDivided = isDivided
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                HStack {
                    Text(type)
                    Spacer()
                }
                .frame(width: 120)
                
                Spacer()
                
                HStack {
                    Text(value)
                    
                    Spacer()
                }
            }
            .font(.system(size: 15))
            
            if isDivided {
                Rectangle()
                    .fill(Color(0xC6C6C8))
                    .frame(height: 0.5)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailScreen(.mockWithImage)
    }
}
