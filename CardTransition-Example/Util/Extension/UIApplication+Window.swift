//
//  UIApplication+Window.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

extension UIApplication {
    
    // Key UIWindowScene
    public var activeWindowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive })
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })
    }
    
    /// Key UIWindow
    public var activeWindow: UIWindow? {
        return activeWindowScene?.windows.first(where: \.isKeyWindow)
    }
    
    /// Key UIWindowScene StatusBarFrame
    public var statusBarFrame: CGRect {
        return activeWindowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
    /// Key UIWindow safeAreaInsets
    public var safeAreaInsets: UIEdgeInsets {
        return activeWindow?.safeAreaInsets ?? .zero
    }
}
