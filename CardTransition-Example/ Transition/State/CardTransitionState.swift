//
//  CardTransitionState.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

protocol TransitionArguments {
    // 转场类型
    var type: TransitionType { get }
    // 转场持续时间
    var duration: TimeInterval { get }
}

protocol TransitionState {
    
    var arguments: TransitionArguments { get }
    
    // 起始圆角半径
    var startCornerRadii: CGFloat? { get set }
    // 结束圆角半径
    var endCornerRadii: CGFloat? { get set }
    
    // 起始 alpha
    var startAlpha: CGFloat? { get set }
    // 结束 alpha
    var endAlpha: CGFloat? { get set }
    
    // 起始 effect
    var startEffect: UIVisualEffect? { get set }
    // 结束 effect
    var endEffect: UIVisualEffect? { get set }
    
    // 起始 frame
    var startFrame: CGRect? { get set }
    // 结束 frame
    var endFrame: CGRect? { get set }
    
    // 起始 affineTransform
    var startAffineTransform: CGAffineTransform? { get set }
    // 结束 affineTransform
    var endAffineTransform: CGAffineTransform? { get set }
}

/// 转场状态
struct CardTransitionState: TransitionState {
   
    struct Cover { }
    struct List { }
    
    enum Key: String {
        
        // 导航栏
        case navigationBar
        // 模糊效果
        case blurEffect
        // 内容
        case content
        // 内容封面
        case contentCover
        // 内容阴影
        case contentShadow
        // 介绍
        case contentIntroduce
        // 内容 mask
        case contentMask
        
        // 关闭按钮
        case closeButton
    }
    
    let arguments: TransitionArguments
    
    var startCornerRadii: CGFloat?
    var endCornerRadii: CGFloat?
    
    var startAlpha: CGFloat?
    var endAlpha: CGFloat?
    
    var startEffect: UIVisualEffect?
    var endEffect: UIVisualEffect?
    
    var startFrame: CGRect?
    var endFrame: CGRect?
    
    var startAffineTransform: CGAffineTransform?
    var endAffineTransform: CGAffineTransform?
}

extension CardTransitionState {
    
    static func build(
        _ arguments: CardTransitionState.Cover.Arguments
    ) -> [CardTransitionState.Key: CardTransitionState] {
        var states = [CardTransitionState.Key: CardTransitionState]()
        states[.navigationBar] = CardTransitionState.Cover.buildNavigationBarState(arguments)
        states[.blurEffect] = CardTransitionState.Cover.buildBlurEffectState(arguments)
        states[.content] = CardTransitionState.Cover.buildContentState(arguments)
        states[.contentCover] = CardTransitionState.Cover.buildContentCoverState(arguments)
        states[.contentShadow] = CardTransitionState.Cover.buildContentShadowState(arguments)
        states[.contentIntroduce] = CardTransitionState.Cover.buildContentIntroduceState(arguments)
        states[.contentMask] = CardTransitionState.Cover.buildContentMaskState(arguments)
        states[.closeButton] = CardTransitionState.Cover.buildCloseButtonState(arguments)
        return states
    }
    
    static func build(
        _ arguments: CardTransitionState.List.Arguments
    ) -> [CardTransitionState.Key: CardTransitionState] {
        var states = [CardTransitionState.Key: CardTransitionState]()
        states[.closeButton] = CardTransitionState.List.buildCloseButtonState(arguments)
        states[.content] = CardTransitionState.List.buildCardContentState(arguments)
        return states
    }
}
