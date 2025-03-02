import SwiftUI

public struct MenuItemView: View {
    let item: MenuItemType
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                item.icon
                
                Text(item.title)
                    .font(.system(size: 17))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(0x3C3C43).opacity(0.6))
            }
            .frame(height: 59)
            
            Divider()
        }
        .hSpacing()
        .padding(.horizontal, 16)
    }
}
