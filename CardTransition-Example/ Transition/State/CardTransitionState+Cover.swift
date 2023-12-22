//
//  CardTransitionState+SingleCard.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

/// 单个卡片
extension CardTransitionState.Cover {
    
    struct Arguments: TransitionArguments {
        
        let type: TransitionType
        let duration: TimeInterval
        
        var navigationStartAlpha: CGFloat
        var navigationEndAlpha: CGFloat
        
        var contentShadowStartTransform: CGAffineTransform?
        var contentShadowEndTransform: CGAffineTransform?
        var contentShadowStartFrame: CGRect
        var contentShadowEndFrame: CGRect
        var contentShadowStartCornerRadii: CGFloat
        var contentShadowEndCornerRadii: CGFloat
        
        var contentMaskStartFrame: CGRect
        var contentMaskEndFrame: CGRect
        
        var contentCoverStartFrame: CGRect
        var contentCoverEndFrame: CGRect
        
        var contentIntroduceStartOffset: CGPoint
        var contentIntroduceEndOffset: CGPoint
        
        var closeButtonStartAlpha: CGFloat
        var closeButtonEndAlpha: CGFloat
        
        var closeButtonStartFrame: CGRect
        var closeButtonEndFrame: CGRect
    }
    
    static func buildNavigationBarState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startAlpha = arguments.navigationStartAlpha
        state.endAlpha = arguments.navigationEndAlpha
        switch arguments.type {
        case .present:
            break
        case .dismiss:
            state.startEffect = nil
            state.endEffect = UIBlurEffect(style: .systemChromeMaterial)
        }
        return state
    }
    
    static func buildBlurEffectState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        switch arguments.type {
        case .present:
            state.startEffect = nil
            state.endEffect = UIBlurEffect(style: .systemThinMaterialDark)
        case .dismiss:
            state.startEffect = UIBlurEffect(style: .systemThinMaterialDark)
            state.endEffect = nil
        }
        return state
    }
    
    static func buildContentShadowState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.contentShadowStartFrame
        state.endFrame = arguments.contentShadowEndFrame
        state.startCornerRadii = arguments.contentShadowStartCornerRadii
        state.endCornerRadii = arguments.contentShadowEndCornerRadii
        switch arguments.type {
        case .present:
            break
        case .dismiss:
            state.startAffineTransform = arguments.contentShadowStartTransform
            state.endAffineTransform = arguments.contentShadowEndTransform
        }
        return state
    }
    
    static func buildContentState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startCornerRadii = arguments.contentShadowStartCornerRadii
        state.endCornerRadii = arguments.contentShadowEndCornerRadii
        return state
    }
    
    static func buildContentMaskState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.contentMaskStartFrame
        state.endFrame = arguments.contentMaskEndFrame
        state.startCornerRadii = arguments.contentShadowStartCornerRadii
        state.endCornerRadii = arguments.contentShadowEndCornerRadii
        return state
    }
    
    static func buildContentCoverState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.contentCoverStartFrame
        state.endFrame = arguments.contentCoverEndFrame
        switch arguments.type {
        case .present:
            break
        case .dismiss:
            state.startCornerRadii = 0
            state.endCornerRadii = arguments.contentShadowEndCornerRadii
        }
        return state
    }
    
    static func buildContentIntroduceState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        let startOffset = arguments.contentIntroduceStartOffset
        state.startAffineTransform = arguments.contentShadowEndTransform?.concatenating(
            CGAffineTransform(translationX: startOffset.x, y: startOffset.y)
        )
        let endOffset = arguments.contentIntroduceEndOffset
        state.endAffineTransform = arguments.contentShadowEndTransform?.concatenating(
            CGAffineTransform(translationX: endOffset.x, y: endOffset.y)
        )
        switch arguments.type {
        case .present:
            state.startAlpha = 0.0
            state.endAlpha = 1.0
            
        case .dismiss:
            state.startAlpha = 1.0
            state.endAlpha = 0.0
        }
        return state
    }
    
    static func buildCloseButtonState(_ arguments: Arguments) -> CardTransitionState {
        var state = CardTransitionState(arguments: arguments)
        state.startFrame = arguments.closeButtonStartFrame
        state.endFrame = arguments.closeButtonEndFrame
        state.startAlpha = arguments.closeButtonStartAlpha
        state.endAlpha = arguments.closeButtonEndAlpha
        return state
    }
    
}
