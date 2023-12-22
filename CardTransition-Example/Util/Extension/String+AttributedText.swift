//
//  String+AttributedText.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

extension String {
    
    // swiftlint:disable function_default_parameter_at_end
    /// 附带设置 baselineOffset
    public func attributedString(
        font: UIFont,
        color: UIColor,
        alpha: CGFloat = 1.0,
        alignment: NSTextAlignment = .left,
        lineSpacing: CGFloat? = nil,
        minimumLineHeight: CGFloat? = nil,
        maximumLineHeight: CGFloat? = nil,
        baselineOffset: CGFloat? = 0
    ) -> NSMutableAttributedString {
        
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = alignment
        if let lineSpacing = lineSpacing {
            paraph.lineSpacing = lineSpacing
        }
        if let lineHeight = minimumLineHeight {
            paraph.minimumLineHeight = lineHeight
        }
        if let lineHeight = maximumLineHeight {
            paraph.maximumLineHeight = lineHeight
        }
        
        let attributedText = NSMutableAttributedString(
            string: self,
            attributes: [
                .font: font,
                .foregroundColor: color.withAlphaComponent(alpha),
                .baselineOffset: baselineOffset ?? 0,
                .paragraphStyle: paraph
            ]
        )
        return attributedText
    }
}
