#if canImport(UIKit)
import UIKit

/// Apply tint color to image
public class TintImageProcessor: ImageProcessor {
  private let tintColor: UIColor

  public init(tintColor: UIColor) {
    self.tintColor = tintColor
  }

    public func process(image: Image) -> Image {
        
        var format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        
        
        let image = renderer.image { [weak self] context in
            guard let self else { return }
            let cgContext = context.cgContext
            
            let rect = CGRect(x: 0, y: 0,
                              width: image.size.width,
                              height: image.size.height)
            
            cgContext.translateBy(x: 0, y: image.size.height)
            cgContext.scaleBy(x: 1.0, y: -1.0)
            
            self.apply(tintColor: tintColor,
                       onto: image,
                       context: cgContext, rect: rect)
            
        }
        
        return image
    }
    
  private func apply(tintColor: UIColor,
                     onto image: UIImage,
                     context: CGContext,
                     rect: CGRect) {
    guard let cgImage = image.cgImage else {
      return
    }

    context.setBlendMode(.normal)
    UIColor.black.setFill()
    context.fill(rect)

    context.setBlendMode(.normal)
    context.draw(cgImage, in: rect)

    context.setBlendMode(.color)
    tintColor.setFill()
    context.fill(rect)

    context.setBlendMode(.destinationIn)
    context.draw(cgImage, in: rect)
  }
}
#endif
