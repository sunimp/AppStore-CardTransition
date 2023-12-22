//
//  UIView+StackView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit

extension UIView {
    
    /// 固定长度的空白视图
    public static func fixedSpace(
        axis: NSLayoutConstraint.Axis = .horizontal,
        length: CGFloat = 0.0
    ) -> UIView {
        guard length > 0 else {
            return UIView()
        }
        let view = UIView()
        view.snp.makeConstraints { make in
            if axis == .horizontal {
                make.width.equalTo(length)
            } else {
                make.height.equalTo(length)
            }
        }
        return view
    }
    
    /// 弹性的空白视图
    public static func flexSpace(axis: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: axis)
        view.setContentCompressionResistancePriority(.defaultLow, for: axis)
        view.snp.makeConstraints { make in
            if axis == .horizontal {
                make.width.equalTo(9_999).priority(.low)
            } else {
                make.height.equalTo(9_999).priority(.low)
            }
        }
        return view
    }
}

extension UIStackView {
    
    public func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
    public func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach { self.removeArrangedSubview($0) }
    }
}
