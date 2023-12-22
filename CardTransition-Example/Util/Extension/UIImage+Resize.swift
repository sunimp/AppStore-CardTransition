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
}
