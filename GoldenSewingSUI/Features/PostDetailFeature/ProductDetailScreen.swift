import ModelsKit
import SwiftUI
import Utilities

public struct ProductDetailScreen: View {
    let product: ProductModel
    
    public var body: some View {
        ScrollView {
            VStack {
                ProductPreviewGalleryView(product.images)
                
                HStack {
                    Text(product.title)
                        .padding(.top, 30)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                VStack(spacing: 10) {
                    ProductPropertiesView(
                        type: "Артикул",
                        value: "\(product.id.value)"
                    )
                    
                    ForEach(0..<product.attributes.count, id: \.self) { index in
                        ProductPropertiesView(
                            type: product.attributes[index].name,
                            value: product.attributes[index].value.joined(separator: ", "),
                            isDivided: index != product.attributes.count - 1
                        )
                    }
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
            }
            .padding(.horizontal, 16)
        }
        .padding([.top, .bottom], 16)
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
