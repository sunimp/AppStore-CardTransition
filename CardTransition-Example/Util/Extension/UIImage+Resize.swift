//
//  UIImage+Resize.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

extension UIImage {
    
    public func resize(_ size: CGSize) -> UIImage {
        guard size.width > 0 && size.height > 0 else {
            return self
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        let render = UIGraphicsImageRenderer(size: size, format: format)
        return render.image { [weak self] context in
            guard let self else { return }
            
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
    
    public func tint(_ color: UIColor) -> UIImage {
        return self.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    public func make(_ color: UIColor, size: CGSize? = nil) -> UIImage {
        if let size {
            return tint(color).resize(size)
        }
        return tint(color)
    }
    
    public func getColor(at point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * 1
        let bitsPerComponent = 8
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        
        let context = CGContext(data: pixelData,
                                width: 1,
                                height: 1,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)
        
        context?.translateBy(x: -point.x, y: -point.y)
        
        context?.draw(
            cgImage,
            in: .only(size: self.size)
        )
        
        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0
        let alpha = CGFloat(pixelData[3]) / 255.0
        
        let resultColor = UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        pixelData.deallocate()
        return resultColor
    }
    
    /// 检查颜色是否在给定的区间内
    public func isColorInRange(color: UIColor, targetColor: UIColor, tolerance: CGFloat) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        color.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        targetColor.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let deltaRed = abs(red1 - red2)
        let deltaGreen = abs(green1 - green2)
        let deltaBlue = abs(blue1 - blue2)
        let deltaAlpha = abs(alpha1 - alpha2)
        
        return deltaRed <= tolerance && 
        deltaGreen <= tolerance &&
        deltaBlue <= tolerance &&
        deltaAlpha <= tolerance
    }
}
