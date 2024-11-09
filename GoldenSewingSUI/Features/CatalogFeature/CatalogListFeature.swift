import Combine
import Constants
import ModelsKit
import SwiftUI

// TODO: Add design system support
struct CatalogListFeature: View {
    @StateObject private var vm = CatalogListViewModel()
    
    private var columns = [
        GridItem(.adaptive(minimum: 167), spacing: 8)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(vm.categories) { category in
                    CategoryItemView(category: category)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Каталог")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoryItemView: View {
    @Injected(\.router) private var router
    
    let category: CategoryModel
    
    var body: some View {
        Button {
            router.push(.productsList(category))
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 162)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.12), radius: 5)
                .overlay {
                    VStack(alignment: .leading, spacing: 4) {
                        Constants.Category.preview(category.id.value)
                            .resizable()
                            .frame(maxHeight: 120)
                            .cornerRadius(6)
                            .padding([.top, .horizontal], 10)
                        Text(Constants.Category.title(category.id.value))
                            .font(.system(size: 13, weight: .medium))
                            .frame(height: 18)
                            .padding(.horizontal, 10)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CatalogListFeature()
}
