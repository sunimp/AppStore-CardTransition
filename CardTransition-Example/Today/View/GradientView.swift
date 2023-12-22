//
//  GradientView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

final class GradientView: UIView {
    
    enum Direction {
        case topToBottom
        case leftToRight
        case topLeftToBottomRight
        case topRightToBottomLeft
    }
    
    let gradientLayer = CAGradientLayer()
    
    var isNeedAnimation: Bool = false
    var duration: CFTimeInterval = 0.3
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.gradientLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.gradientLayer)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        _ colors: [(UIColor, NSNumber)],
        direction: Direction
    ) {
        let isNeed = self.isNeedAnimation
        if !isNeed {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
        }
        switch direction {
        case .leftToRight:
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .topToBottom:
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .topLeftToBottomRight:
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
        case .topRightToBottomLeft:
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            
        }
        self.gradientLayer.colors = colors.map({ $0.0.cgColor })
        self.gradientLayer.locations = colors.map({ $0.1 })
        if !isNeed {
            CATransaction.commit()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.isNeedAnimation {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.gradientLayer.frame = self.bounds
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.duration)
            self.gradientLayer.frame = self.bounds
            CATransaction.commit()
        }
    }
}
