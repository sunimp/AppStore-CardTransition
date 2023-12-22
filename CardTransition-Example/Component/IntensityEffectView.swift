//
//  IntensityEffectView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

final class IntensityEffectView: UIVisualEffectView {
    
    private let visualEffect: UIVisualEffect
    var intensity: CGFloat {
        didSet {
            self.setNeedsDisplay()
        }
    }
    private var animator: UIViewPropertyAnimator?
    
    init(effect: UIVisualEffect, intensity: CGFloat = 1.0) {
        visualEffect = effect
        self.intensity = intensity
        
        super.init(effect: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            guard let self else { return }
            
            self.effect = visualEffect
        }
        animator?.fractionComplete = self.intensity
    }
    
    deinit {
        animator?.stopAnimation(true)
    }
}
