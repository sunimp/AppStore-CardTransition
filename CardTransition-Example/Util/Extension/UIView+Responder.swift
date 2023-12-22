//
//  UIView+Responder.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

extension UIView {
    
    public func viewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
}
