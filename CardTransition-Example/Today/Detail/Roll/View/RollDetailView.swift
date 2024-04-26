//
//  RollDetailView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/25.
//

import UIKit

import SnapKit

final class RollDetailView: DetailView<UITableView> {
    
    override func setup() {
        super.setup()
        
        let converHeight = (Util.screenHeight - Util.statusBarHeight) / 2 + Util.statusBarHeight
        scrollView.verticalScrollIndicatorInsets = .only(top: converHeight - Util.safeAreaInsets.top)
        
    }
    
    override func configure(_ event: Event) {
        super.configure(event)
    }
}

