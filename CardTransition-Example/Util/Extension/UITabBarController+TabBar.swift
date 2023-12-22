//
//  UITabBarController+TabBar.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/22.
//

import UIKit

extension UITabBarController {
    
    public func setTabBarHidden(_ isHidden: Bool) {
        guard let vc = selectedViewController else { return }
        guard isTabBarHidden != isHidden else { return }
        
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = isHidden ? height : -height
        
        self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        self.selectedViewController?.view.frame = CGRect(
            x: 0,
            y: 0,
            width: vc.view.frame.width,
            height: vc.view.frame.height + offsetY
        )
        
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
    
    private var isTabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }
}
