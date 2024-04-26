//
//  ListDetailView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/25.
//

import UIKit

import SnapKit

final class ListDetailView: DetailView<UITableView>, UITableViewDataSource, UITableViewDelegate {
    
    override func setup() {
        super.setup()
        
        scrollView.dataSource = self
        
        let converHeight = (Util.screenHeight - Util.statusBarHeight) / 2 + Util.statusBarHeight
        scrollView.verticalScrollIndicatorInsets = .only(top: converHeight - Util.safeAreaInsets.top)
        
    }
    
    override func configure(_ event: Event) {
        super.configure(event)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }
}
