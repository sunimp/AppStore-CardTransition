//
//  UIView+Animation.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

extension UIView {
    
    /// 缩放动画
    public func animateScale(
        _ isHighlighted: Bool,
        duration: TimeInterval = Util.animationDuration,
        scale: CGFloat = 0.96,
        completion: ((Bool) -> Void)? = nil
    ) {
        
        let options: UIView.AnimationOptions = [
            .allowUserInteraction,
            .curveEaseInOut
        ]
        
        if isHighlighted {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: options,
                           animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: options,
                           animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
}
