//
//  UIView+OuterBorder.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/19.
//

import UIKit

private var borderLayerKey: UInt8 = 0

extension CALayer {
    
    private var borderLayer: CAShapeLayer? {
        get {
            objc_getAssociatedObject(self, &borderLayerKey) as? CAShapeLayer
        }
        set {
            objc_setAssociatedObject(self, &borderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension CALayer {
    
    
    /// 设置外部圆角
    ///
    /// - Parameters:
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    ///   - roundingCorners: 圆角
    ///   - cornerRadii: 圆角半径
    ///
    /// - Important: 当 cornerRadii 设置超过或等于宽度或者高度(以最短为准)的 33% 时, 
    /// 会默认变成宽度或者高度(以最短为准)的一半,
    /// 这是 UIBezierPath(roundedRect:byRoundingCorners:cornerRadii:) 这个 API 的默认行为
    ///
    public func makeOuterBorder(
        _ borderColor: UIColor,
        borderWidth: CGFloat,
        roundingCorners: UIRectCorner = .allCorners,
        cornerRadii: CGFloat? = nil
    ) {
        self.borderLayer?.removeFromSuperlayer()
        
        let bounds = self.bounds
        let borderRect = bounds.insetBy(dx: -borderWidth, dy: -borderWidth)
        
        if let radii = cornerRadii, radii > 0, roundingCorners.rawValue > 0 {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = borderRect
            let pathRect = CGRect(
                x: .zero,
                y: .zero,
                width: borderRect.width,
                height: borderRect.height
            )
            let maskPath = UIBezierPath(
                roundedRect: pathRect,
                byRoundingCorners: roundingCorners,
                cornerRadii: CGSize(width: radii + borderWidth / 2, height: radii + borderWidth / 2)
            )
            maskLayer.path  = maskPath.cgPath
            self.mask = maskLayer
        }
        
        if borderWidth > 0 {
            let pathRect = CGRect(
                x: borderWidth / 2,
                y: borderWidth / 2,
                width: bounds.width + borderWidth,
                height: bounds.height + borderWidth
            )
            
            let borderLayer = CAShapeLayer()
            let borderPath: UIBezierPath
            if let radii = cornerRadii, radii > 0, roundingCorners.rawValue > 0 {
                borderPath = UIBezierPath(
                    roundedRect: pathRect,
                    byRoundingCorners: roundingCorners,
                    cornerRadii: CGSize(width: radii, height: radii)
                )
            } else {
                borderPath = UIBezierPath(rect: pathRect)
            }
            borderLayer.path = borderPath.cgPath
            borderLayer.frame = borderRect
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineWidth = borderWidth
            
            self.insertSublayer(borderLayer, at: 0)
            self.borderLayer = borderLayer
        }
    }
}

extension UIView {
    
    public func makeOuterBorder(
        _ borderColor: UIColor,
        borderWidth: CGFloat,
        roundingCorners: UIRectCorner = .allCorners,
        cornerRadii: CGFloat? = nil
    ) {
        self.layer.makeOuterBorder(
            borderColor,
            borderWidth: borderWidth,
            roundingCorners: roundingCorners,
            cornerRadii: cornerRadii
        )
    }
}
