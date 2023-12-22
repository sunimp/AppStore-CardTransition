//
//  TabBarController+Module.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

extension TabBarController {
    
    enum Module: Hashable {
        case today
        case games
        case apps
        case search
        
        var title: String {
            switch self {
            case .today:
                return "Today"
            case .games:
                return "Game"
            case .apps:
                return "App"
            case .search:
                return "Search"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .today:
                return UIImage(systemName: "doc.text.image")?
                    .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case .games:
                return UIImage(systemName: "gamecontroller")?
                    .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case .apps:
                return UIImage(systemName: "square.stack.3d.up.fill")?
                    .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case .search:
                return UIImage(systemName: "magnifyingglass")?
                    .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .today:
                return UIImage(systemName: "doc.text.image")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .games:
                return UIImage(systemName: "gamecontroller")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .apps:
                return UIImage(systemName: "square.stack.3d.up.fill")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .search:
                return UIImage(systemName: "magnifyingglass")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            }
        }
           
        var tabBarItem: UITabBarItem {
            UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
        }
        
        var viewController: UIViewController {
            let vc: UIViewController
            switch self {
            case .today:
                vc = TodayViewController()
            case .games:
                vc = GamesViewController()
            case .apps:
                vc = AppsViewController()
            case .search:
                vc = SearchViewController()
            }
            vc.tabBarItem = self.tabBarItem
            vc.title = self.title
            vc.navigationItem.largeTitleDisplayMode = .automatic
            return NavigationController(rootViewController: vc)
        }
        
    }
}
