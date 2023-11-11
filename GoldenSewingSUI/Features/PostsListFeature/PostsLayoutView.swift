import ComposableArchitecture
import SwiftUI

struct MasonryLayout: Layout {
    var columns: Int
    var spacing: Double
    
    init(columns: Int = 3, spacing: Double = 5) {
        self.columns = max(1, columns)
        self.spacing = spacing
    }
    
    private func frames(for subviews: Subviews, in totalWidth: Double) -> [CGRect] {
        let totalSpacing = spacing * Double(columns - 1)
        let columnWidth = (totalWidth - totalSpacing) / Double(columns)
        let columnWidthWithSpacing = columnWidth + spacing
        let proposedSize = ProposedViewSize(width: columnWidth, height: nil)
        
        var viewFrames = [CGRect]()
        var columnHeights = Array(repeating: 0.0, count: columns)
        
        for subview in subviews {
            var selectedColumn = 0
            var selectedHeight = Double.greatestFiniteMagnitude
            
            for (columnIndex, height) in columnHeights.enumerated() {
                if height < selectedHeight {
                    selectedColumn = columnIndex
                    selectedHeight = height
                }
            }
            
            let x = Double(selectedColumn) * columnWidthWithSpacing
            let y = columnHeights[selectedColumn]
            let size = subview.sizeThatFits(proposedSize)
            let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            columnHeights[selectedColumn] += size.height + spacing
            
            viewFrames.append(frame)
        }
        
        return viewFrames
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewFrames = frames(for: subviews, in: width)
        let height = viewFrames.max { $0.maxY < $1.maxY } ?? .zero
        
        return CGSize(width: width, height: height.maxY)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let viewFrames = frames(for: subviews, in: bounds.width)
        
        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY)
            subviews[index].place(at: position, proposal: ProposedViewSize(frame.size))
        }
    }
    
}

struct PostsLayoutView: View {
    let posts: IdentifiedArrayOf<PostDTO>
    let postTapped: (PostDTO) -> Void
    
    var body: some View {
        ScrollView {
            MasonryLayout(columns: 2, spacing: 8) {
                ForEach(posts) { post in
                    PostListItemView(post: post)
                        .onTapGesture {
                            postTapped(post)
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    PostsLayoutView(
        posts: [.mock, .mock2],
        postTapped: { _ in }
    )
}
