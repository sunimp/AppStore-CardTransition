//
//  TodayCoverCell.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit
import SDWebImage

final class TodayCoverCell: TodayCardCell {
    
    let coverView = TodayCoverView()
    
    var event: Event?
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ event: Event) {
        self.event = event
        coverView.configure(event)
    }
}
