//
//  UIView+CardTransition.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

private var viewStateKeyContext: UInt8 = 0

extension UIView {
    
    var stateKey: CardTransitionState.Key? {
        get {
            guard let key = objc_getAssociatedObject(self, &viewStateKeyContext) as? String else {
                return nil
            }
            return CardTransitionState.Key(rawValue: key)
        }
        set {
            objc_setAssociatedObject(self, &viewStateKeyContext, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func prepareTransition(for states: [CardTransitionState.Key: TransitionState]) {
        guard let state = getTransitionState(of: states) else { return }
        start(from: state)
    }
    
    func transition(to states: [CardTransitionState.Key: TransitionState]) {
        guard let state = getTransitionState(of: states) else { return }
        end(to: state)
    }
    
    private func getTransitionState(of states: [CardTransitionState.Key: TransitionState]) -> TransitionState? {
        guard let stateKey = self.stateKey else { return nil }
        return states[stateKey]
    }
}

extension UIView {
    
    private func start(from state: TransitionState) {
        
        if let alpha = state.startAlpha {
            self.alpha = alpha
        }
        
        if let view = self as? UIVisualEffectView {
            view.effect = state.startEffect
        }
        
        if let frame = state.startFrame {
            self.frame = frame
        }
        
        if let transform = state.startAffineTransform {
            self.transform = transform
        }
        
        if let cornerRadii = state.startCornerRadii {
            self.layer.cornerRadius = cornerRadii
        }
    }
    
    private func end(to state: TransitionState) {
        
        if let alpha = state.endAlpha {
            self.alpha = alpha
        }
        
        if let view = self as? UIVisualEffectView {
            view.effect = state.endEffect
        }
        
        if let transform = state.endAffineTransform {
            self.transform = transform
            if let frame = state.endFrame {
                self.frame = frame
            }
        } else {
            if let frame = state.endFrame {
                self.frame = frame
            }
        }
        
        if let cornerRadii = state.endCornerRadii {
            self.layer.cornerRadius = cornerRadii
        }
    }
}
