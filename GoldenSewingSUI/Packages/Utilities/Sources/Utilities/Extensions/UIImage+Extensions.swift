import AVFoundation
import UIKit

public extension UIImage {
    func resize(_ width: CGFloat, _ height: CGFloat) -> UIImage {
        let maxSize = CGSizeMake(width, height)
        
        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(
            size: targetSize,
            format: format
        )
        
        let resized = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}
