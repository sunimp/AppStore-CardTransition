//
//  Util.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/19.
//

import UIKit

public enum Util {
    
    public static let split: CGFloat = 1 / UIScreen.main.scale
    
    public static let spacing: CGFloat = 4
    public static let spacingLarge: CGFloat = 8
    
    public static let margin: CGFloat = 16
    public static let marginLarge: CGFloat = 20
    
    public static let screenSize: CGSize = CGSize(width: screenWidth, height: screenHeight)
    public static let screenWidth: CGFloat = UIScreen.main.bounds.width
    public static let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    public static let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
    public static var statusBarHeight: CGFloat {
        statusBarFrame.height
    }
    
    public static var keyWindow: UIWindow? {
        UIApplication.shared.activeWindow
    }
    
    public static var safeAreaInsets: UIEdgeInsets {
        keyWindow?.safeAreaInsets ?? .zero
    }
    
    public static var topVC: UIViewController? {
        let window = self.keyWindow ?? UIApplication.shared.windows.first(where: { $0.rootViewController != nil })
        
        return window?.rootViewController?.topVC
    }
    
    public static let animationDuration: TimeInterval = 0.25
}
