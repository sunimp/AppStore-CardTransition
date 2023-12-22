//
//  CGGemotry+Convenience.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

// MARK: - CGFloat
extension CGFloat {
    
    public var makeCeil: CGFloat {
        ceil(self)
    }
    
    public var removeFloatMin: CGFloat {
        guard self != .leastNormalMagnitude,
              self != .leastNonzeroMagnitude else { return 0 }
        return self
    }
    
    public func flatSpecificScale(_ scale: CGFloat = 0) -> CGFloat {
        let value = removeFloatMin
        return ceil(value * scale) / scale
    }
    
    public var flat: CGFloat {
        return flatSpecificScale(UIScreen.main.scale)
    }
    
    public func centre(_ other: CGFloat) -> CGFloat {
        return ((self - other) / 2.0).flat
    }
}

extension CGRect {
    // MARK: - CGRect
    
    public func dividedIntegral(
        fraction: CGFloat,
        from fromEdge: CGRectEdge
    ) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
    
    public var flatted: CGRect {
        return CGRect(
            x: origin.x.flat,
            y: origin.y.flat,
            width: size.width.flat,
            height: size.height.flat
        )
    }
    
    public var makeCeil: CGRect {
        CGRect(
            x: origin.x.makeCeil,
            y: origin.y.makeCeil,
            width: size.width.makeCeil,
            height: size.height.makeCeil
        )
    }
    
    public func setX(_ x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x.flat
        return rect
    }
    
    public func setY(_ y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y.flat
        return rect
    }
    
    public func setXY(_ x: CGFloat, _ y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x.flat
        rect.origin.y = y.flat
        return rect
    }
    
    public func setWidth(_ width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width.flat
        return rect
    }
    
    public func setHeight(_ height: CGFloat) -> Self {
        var rect = self
        rect.size.height = height.flat
        return rect
    }
}

extension CGPoint {
    
    public enum ScrollDirection {
        case up, left, right, down, none
    }
    
    public func checkScrollDirection() -> ScrollDirection {
        let absX = abs(x)
        let absY = abs(y)
        
        if absX > absY {
            if x < 0 {
                return .left
            } else {
                return .right
            }
        } else if absY > absX {
            if y < 0 {
                return .up
            } else {
                return .down
            }
        }
        return .none
    }
}

extension UIEdgeInsets {
    // MARK: - UIEdgeInsets
    
    public static func only(
        top: CGFloat = 0.0,
        left: CGFloat = 0.0,
        bottom: CGFloat = 0.0,
        right: CGFloat = 0.0
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    public static func symmetric(
        vertical: CGFloat = 0.0,
        horizontal: CGFloat = 0.0
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    public static func all(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    public var horizontal: CGFloat {
        return self.left + self.right
    }
    
    public var vertical: CGFloat {
        return self.top + self.bottom
    }
    
    public var removeFloatMin: UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top.removeFloatMin,
            left: self.left.removeFloatMin,
            bottom: self.bottom.removeFloatMin,
            right: self.right.removeFloatMin
        )
    }
}

extension BinaryFloatingPoint {
    
    /// Bool Value
    public var bool: Bool {
        return 0 != self
    }
    
    /// CGFloat Value
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /// Double Value
    public var double: Double {
        return Double(self)
    }
    
    /// Float Value
    public var float: Float {
        return Float(self)
    }
    
    /// Int Value
    public var int: Int {
        return Int(self)
    }
    
    /// Int8 Value
    public var int8: Int8 {
        return Int8(self)
    }
    
    /// Int16 Value
    public var int16: Int16 {
        return Int16(self)
    }
    
    /// Int32 Value
    public var int32: Int32 {
        return Int32(self)
    }
    
    /// Int64 Value
    public var int64: Int64 {
        return Int64(self)
    }
    
    /// UInt Value
    public var uInt: UInt {
        return UInt(self)
    }
    
    /// UInt8 Value
    public var uInt8: UInt8 {
        return UInt8(self)
    }
    
    /// UInt16 Value
    public var uInt16: UInt16 {
        return UInt16(self)
    }
    
    /// UInt32 Value
    public var uInt32: UInt32 {
        return UInt32(self)
    }
    
    /// UInt64 Value
    public var uInt64: UInt64 {
        return UInt64(self)
    }
}
