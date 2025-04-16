import SwiftUI

public struct MenuItemRow: View, Identifiable {
    public var id: String { title }
    
    let title: String
    let elements: [MenuRowElement]
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(0x871A1A))
                .padding(.bottom, 3)
            
            ForEach(elements, id: \.self) { element in
                HStack(alignment: .top) {
                    if element.isDotted {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .padding(.top, 7)
                    }
                    Text(element.value)
                        .font(.system(size: 13))
                }
            }
        }
    }
}

public struct MenuRowElement: Identifiable, Hashable {
    public var id: String { value }
    
    let value: String
    let isDotted: Bool
    
    public init(value: String, isDotted: Bool = true) {
        self.value = value
        self.isDotted = isDotted
    }
}
