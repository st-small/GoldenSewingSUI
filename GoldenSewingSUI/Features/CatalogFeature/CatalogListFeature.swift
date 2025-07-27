import Combine
import Constants
import ModelsKit
import SwiftUI

// TODO: Add design system support
struct CatalogListFeature: View {
	@Injected(\.dbProvider) private var dbProvider
	@Injected(\.router) private var router
	
	@State var categories: [CategoryViewModel]
	
	public init(categories: [CategoryViewModel] = []) {
		self.categories = categories
	}
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: [.init(.adaptive(minimum: 200))]) {
				ForEach(categories) { category in
					CategoryItemView(category: category)
				}
			}
		}
		.padding(.bottom, 32)
		.navigationTitle("Каталог")
		.navigationBarTitleDisplayMode(.inline)
		.task {
			guard
				categories.isEmpty,
				let dbCategories = try? await dbProvider.getAllCategories()
			else { return }
			
			for category in dbCategories.sorted(by: { $0.priority > $1.priority }) {
				let categoryVM = await CategoryViewModel(category)
				categories.append(categoryVM)
			}
		}
	}
}

struct CategoryItemView: View {
	@Injected(\.router) private var router
	
	let category: CategoryViewModel
	
	private var images: [ImageModel] {
		if category.id == .init(0) {
			let images = category.items[0].images ?? []
			return Array(images.shuffled().prefix(4)).map { $0 }
		} else {
			return category.items.compactMap { $0.images?[0] }
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			VStack(alignment: .leading) {
				HStack(alignment: .top) {
					Text(category.model.title)
						.font(.system(size: 20, weight: .semibold))
					
					Spacer()
					
					Button {
						router.push(.productsList(category.model))
					} label: {
						Text("Все")
							.font(.caption)
							.foregroundStyle(Color(0x871A1A))
							.padding(.vertical, 3)
							.padding(.horizontal, 10)
							.background(
								RoundedRectangle(
									cornerRadius: 20,
									style: .continuous
								)
								.stroke(Color(0x871A1A), lineWidth: 1)
							)
					}
				}
				
				Text(category.model.subtitle)
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.horizontal, 16)
			
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 8) {
					if category.id == CategoryID(0) {
						geraldikaView
					} else {
						categoryView
					}
				}
				.padding(.vertical, 5)
			}
			.contentMargins(.horizontal, 16, for: .scrollContent)
		}
		.padding(.top, 24)
	}
	
	private var categoryView: some View {
		ForEach(category.items) { item in
			ImageViewContainer(
				model: item.images![0],
				mode: .fill,
				onTapped: {
					router.push(.productDetail(item))
				}
			)
			.frame(width: 100, height: 100)
			.cornerRadius(8)
			.shadow(
				color: .black.opacity(0.3),
				radius: 2, x: 1, y: 2
			)
		}
	}
	
	private var geraldikaView: some View {
		ForEach(Array(category.items[0].images!.enumerated()), id: \.element.id) { index, item in
			ImageViewContainer(
				model: item,
				mode: .fill,
				onTapped: {
					router.push(.gallery(index))
					
				}
			)
			.frame(width: 100, height: 100)
			.cornerRadius(8)
			.shadow(
				color: .black.opacity(0.3),
				radius: 2, x: 1, y: 2
			)
		}
	}
}

//#Preview {
//	NavigationStack {
//		CatalogListFeature(categories: [.init(.mock)])
//	}
//}
