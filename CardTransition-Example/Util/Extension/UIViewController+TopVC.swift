//
//  UIViewController+TopVC.swift
//  CardTransition-Example
//
//  Created by Sun on 2024/4/26.
//

import UIKit

extension UIViewController {
    
    /// 顶层 vc
    public var topVC: UIViewController {
        if let vc = self.presentedViewController {
            return vc.topVC
        } else if let tabVC = self as? UITabBarController,
            let vc = tabVC.selectedViewController {
            return vc.topVC
            
        } else if let nav = self as? UINavigationController,
                  let vc = nav.visibleViewController {
            return vc.topVC
        }
        return self
    }
    
}
