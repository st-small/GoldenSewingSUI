import ModelsKit
import SwiftUI
import Utilities

public struct ProductDetailScreen: View {
    let product: ProductModel
    
    public var body: some View {
        ScrollView {
            ProductPreviewGalleryView(product.images)
            
            HStack {
                Text(product.title)
                    .padding(.top, 30)
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            VStack {
                ProductPropertiesView(
                    type: "Артикул",
                    value: "7598"
                )
                ProductPropertiesView(
                    type: "Ткань",
                    value: "Парча"
                )
                ProductPropertiesView(
                    type: "Способ изготовления",
                    value: "Золотая и серебряная канитель, Машинная вышивка, Метанит, Ручная инкрустация канителью, Трунцал"
                )
                ProductPropertiesView(
                    type: "Инкрустация",
                    value: "Горный хрусталь, Гранат, Жемчуг, Нефрит, Сердолик, Стразы \"Сваровски\", Живопись темперой",
                    isDivided: false
                )
            }
            .padding(.top, 16)
            
            Button {
                
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
            .padding(.top, 16)

            
            Spacer()
        }
        .padding([.horizontal, .top], 16)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(product.title)
                    .multilineTextAlignment(.center)
                    .font(.headline)
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
        ProductDetailScreen(product: .mockWithImage)
    }
}