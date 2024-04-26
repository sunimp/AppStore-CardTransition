//
//  TodayRollCell.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/25.
//

import UIKit

import SnapKit
import SDWebImage

final class TodayRollCell: TodayCardCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setup() {
        super.setup()
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
    }
    
    func configure(_ event: Event, count: Int = 5) {
        
    }
}
