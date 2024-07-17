import ModelsKit
import SwiftDataProviderKit
import SwiftUI
/*
struct Sample2View: View {
    @EnvironmentObject private var provider: DataProvider
    
    var body: some View {
        NavigationView {
            Group {
                if provider.categories.isEmpty {
                    Text("No data")
                } else {
                    List {
                        ForEach(provider.categories) { category in
                            Product2View(category: category)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        let id = Int32.random(in: 0...1000)
                        let title = "Instruments \(id)"
                        provider.addCategory(CategoryID(id), title: title)
                    } label: {
                        Label(
                            title: { Text("Add") },
                            icon: { Image(systemName: "plus") }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    Sample2View()
        .environmentObject(DataProvider(inMemory: true))
}

struct Product2View: View {
    @EnvironmentObject private var provider: DataProvider
    
    let category: CategoryModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(category.title)")
            
            HStack {
                Button("Select") {
                    provider.updateCategory(category.id, isFavourite: !category.isFavorite)
                }
                Button("Delete") {
                    provider.deleteCategory(category.id)
                }
                Spacer()
                
                if category.isFavorite {
                    Image(systemName: "checkmark")
                }
            }
            .buttonStyle(.bordered)
        }
    }
}
*/
