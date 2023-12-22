//
//  CardTransitionState+ListCard.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

/// 榜单卡片
extension CardTransitionState.List {
    
    struct Arguments: TransitionArguments {
        
        let type: TransitionType
        let duration: TimeInterval
        
        var closeButtonStartFrame: CGRect
        var closeButtonEndFrame: CGRect
        
        var cardContentStartFrame: CGRect
        var cardContentEndFrame: CGRect
    }
    
    static func buildCloseButtonState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.closeButtonEndFrame
        state.endFrame = arguments.closeButtonEndFrame
        
        switch arguments.type {
        case .present:
            state.startAlpha = 0
            state.endAlpha = 1.0
        case .dismiss:
            state.startAlpha = 1.0
            state.endAlpha = 0
        }
        return state
    }
    
    static func buildCardContentState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.cardContentStartFrame
        state.endFrame = arguments.cardContentEndFrame
        return state
    }
}
