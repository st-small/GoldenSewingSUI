import ModelsKit
import SwiftUI

public struct ProductItemView: View {
    let product: PostModel
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
                .frame(height: 170)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold))
                    .frame(maxHeight: .infinity)
                    .border(.cyan)
                
                Text("Артикул: \(product.id.value)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(0x3C3C43))
                    .opacity(0.6)
            }
        }
    }
}

#Preview {
    ProductItemView(product: .mock)
        .frame(width: 167, height: 240)
        .border(.green)
}
