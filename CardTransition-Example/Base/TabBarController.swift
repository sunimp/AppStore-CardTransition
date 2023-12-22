//
//  TabBarController.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let modules: [Module] = [.today, .games, .apps, .search]
    
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcs: [UIViewController] = modules.map { $0.viewController }
        self.setViewControllers(vcs, animated: false)
    }
}
