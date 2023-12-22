//
//  NavigationController.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}
