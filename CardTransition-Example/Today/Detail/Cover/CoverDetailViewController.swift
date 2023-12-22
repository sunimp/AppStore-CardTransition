//
//  CoverDetailViewController.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit

final class CoverDetailViewController: ViewController {
    
    let event: Event
    let detailView = CoverDetailView()
    
    var isHiddenStatusBar: Bool = false
    
    init(_ event: Event) {
        self.event = event
        
        super.init()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailView.configure(event)
        detailView.closeAction = { [weak self] in
            guard let self else { return }
            
            self.actionClose()
        }
    }
}
