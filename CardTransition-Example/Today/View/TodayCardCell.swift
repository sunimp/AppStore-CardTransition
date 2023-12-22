//
//  TodayCardCell.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit

class TodayCardCell: UICollectionViewCell {
    
    static let cornerRadius: CGFloat = 16.0
    
    var didTapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateScale(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateScale(false)
        self.didTapAction?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateScale(false)
    }
    
    func setup() { 
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 12
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        contentView.layer.cornerRadius = Self.cornerRadius
        contentView.layer.masksToBounds = true
    }
}
