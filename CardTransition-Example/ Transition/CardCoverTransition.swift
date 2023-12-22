//
//  CardTransition.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

final class CardCoverTransition: NSObject,
                                 UIViewControllerAnimatedTransitioning,
                                 UIViewControllerTransitioningDelegate {
    
    static let shared = CardCoverTransition()
    
    private var transitionType: TransitionType = .present
    
    var options: UIView.AnimationOptions {
        switch self.transitionType {
        case .present:
            return .curveEaseOut
        case .dismiss:
            return .curveEaseOut
        }
    }
    
    var curve: UIView.AnimationCurve {
        switch self.transitionType {
        case .present:
            return .easeOut
        case .dismiss:
            return .easeOut
        }
    }
    
    private var transitionDuration: TimeInterval {
        switch transitionType {
        case .present:
            return 1.0
        case .dismiss:
            return 0.75
        }
    }
    
    weak var sourceView: TodayCoverCell?
    
    private override init() {
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.transitionType {
        case .present:
            present(using: transitionContext)
        case .dismiss:
            dismiss(using: transitionContext)
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .dismiss
        return self
    }
}

extension CardCoverTransition {
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourceView = self.sourceView,
              let event = sourceView.event,
              let sourceVC = sourceView.viewController() as? TodayViewController,
              let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) as? UINavigationController,
              let detailVC = toVC.children.first as? CoverDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let transitionView = CardCoverTransitionView()
        transitionView.configure(event)
        
        containerView.addSubview(toVC.view)
        toVC.view.frame = containerView.bounds
        toVC.view.isHidden = true
        // 转场时, 为了之后获取到正确的详情页面子视图 frame, 所以这里需要进行强制布局
        toVC.view.layoutIfNeeded()
        
        containerView.addSubview(transitionView)
        transitionView.frame = containerView.bounds
        // 转场时, 隐藏 fromView 的阴影
        sourceView.layer.shadowOpacity = 0
        
        // 1. 导航
        let navigationStartAlpha: CGFloat = sourceVC.navigationBar.alpha
        let navigationEndAlpha: CGFloat = 0
        
        // 2. 卡片
        transitionView.detailView.frame = transitionView.bounds
        
        // 3. 高斯模糊
        let blurHeight: CGFloat
        if let tabBarVC = fromVC as? UITabBarController {
            blurHeight = transitionView.bounds.height - tabBarVC.tabBar.bounds.height
        } else {
            blurHeight = transitionView.bounds.height
        }
        let blurEffectStartFrame = transitionView.bounds.setHeight(blurHeight)
        let blurEffectEndFrame = transitionView.bounds
        
        // 4. 卡片阴影
        let contentShadowStartFrame = sourceView.convert(
            sourceView.bounds,
            to: detailVC.detailView.contentShadowView
        )
        let contentShadowEndFrame = detailVC.detailView.contentShadowView.frame
        let contentShadowStartCornerRadii = sourceView.contentView.layer.cornerRadius
        let contentShadowEndCornerRadii = UIScreen.main.displayCornerRadius
        transitionView.detailView.contentShadowView.frame = contentShadowStartFrame
    
        // 5. 内容 cover
        let contentCoverStartFrame = contentShadowStartFrame.setXY(0, 0)
        let contentCoverEndFrame = detailVC.detailView.coverView.frame
        transitionView.detailView.coverView.frame = contentCoverStartFrame
        
        // 6. mask
        let maskStartFrame = sourceView.bounds
        let maskEndFrame = detailVC.detailView.contentView.bounds
        transitionView.contentMaskView.frame = maskStartFrame
        
        // 7. 关闭按钮
        let closeEndFrame = detailVC.detailView.contentView.convert(
            detailVC.detailView.closeButton.frame,
            to: detailVC.detailView.contentView
        )
        var closeStartFrame = transitionView.detailView.convert(closeEndFrame, to: sourceView)
        closeStartFrame.origin.x -= (contentCoverEndFrame.maxX - contentShadowStartFrame.maxX)
        closeStartFrame = closeStartFrame.setY(closeEndFrame.minY)
        transitionView.detailView.closeButton.frame = closeStartFrame
        
        // 构造 state 参数
        let arguments = CardTransitionState.Cover.Arguments(
            type: self.transitionType,
            duration: self.transitionDuration,
            navigationStartAlpha: navigationStartAlpha,
            navigationEndAlpha: navigationEndAlpha,
            contentShadowStartFrame: contentShadowStartFrame,
            contentShadowEndFrame: contentShadowEndFrame,
            contentShadowStartCornerRadii: contentShadowStartCornerRadii,
            contentShadowEndCornerRadii: contentShadowEndCornerRadii,
            contentMaskStartFrame: maskStartFrame,
            contentMaskEndFrame: maskEndFrame,
            contentCoverStartFrame: contentCoverStartFrame,
            contentCoverEndFrame: contentCoverEndFrame,
            contentIntroduceStartOffset: .zero,
            contentIntroduceEndOffset: .zero,
            closeButtonStartAlpha: 0,
            closeButtonEndAlpha: 1,
            closeButtonStartFrame: closeStartFrame,
            closeButtonEndFrame: closeEndFrame
        )
        // 所有的 states
        let states = CardTransitionState.build(arguments)
        transitionView.animationViews.forEach { $0.prepareTransition(for: states) }
        
        transitionView.setNeedsLayout()
        transitionView.layoutIfNeeded()
        
        let dampingAnimator = UIViewPropertyAnimator(
            duration: transitionDuration,
            dampingRatio: 0.75
        )
        
        dampingAnimator.addAnimations {
            transitionView.immediateViews(self.transitionType).forEach {
                $0.transition(to: states)
            }
        }
        dampingAnimator.addAnimations {
            detailVC.isHiddenStatusBar = true
            detailVC.setNeedsStatusBarAppearanceUpdate()
        }
        
        dampingAnimator.addCompletion { _ in
            transitionView.removeFromSuperview()
            // 转场结束, toVC 的视图取消隐藏
            toVC.view.isHidden = false
            transitionContext.completeTransition(true)
            // 转场结束, 展示 fromView 的阴影
            sourceView.layer.shadowOpacity = 1.0
        }
        dampingAnimator.startAnimation()
        
        let delayAnimator = UIViewPropertyAnimator(
            duration: self.transitionDuration,
            curve: self.curve
        )
        delayAnimator.addAnimations({
            transitionView.delayeViews(self.transitionType).forEach {
                $0.transition(to: states)
            }
        }, delayFactor: 0.25)
        delayAnimator.startAnimation()
        
        // tabBar 隐藏动画
        if let tabBarVC = fromVC as? UITabBarController {
            transitionView.detailView.blurView.frame = blurEffectStartFrame
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: self.transitionDuration / 4,
                delay: 0,
                options: self.options,
                animations: {
                    transitionView.detailView.blurView.frame = blurEffectEndFrame
                    tabBarVC.setTabBarHidden(true)
                }
            )
        }
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UINavigationController,
              let detailVC = fromVC.children.first as?  CoverDetailViewController,
              let targetView = self.sourceView,
              let targetVC = targetView.viewController() as? TodayViewController,
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let event = detailVC.event
        
        // 转场的容器视图
        let containerView = transitionContext.containerView
        // 转场的 frame
        let finalFrame = transitionContext.finalFrame(for: fromVC)
        // 把目的页面的视图加到转场容器视图上
        containerView.addSubview(toVC.view)
        // 设置目的 vc 视图的 frame
        toVC.view.frame = finalFrame
        
        // 转场视图
        let transitionView = CardCoverTransitionView()
        transitionView.configure(event)
        
        // 把转场视图添加到转场容器视图上
        containerView.addSubview(transitionView)
        // 设置转场视图的 frame
        transitionView.frame = finalFrame
        // 转场时, 隐藏 fromVC 的视图
        fromVC.view.isHidden = true
        // 转场时, 隐藏 targetView
        targetView.isHidden = true
       
        // 1. 导航
        let navigationStartAlpha: CGFloat = 0
        let navigationEndAlpha: CGFloat = targetVC.navigationBar.alpha
        
        // 2. 卡片
        transitionView.detailView.frame = transitionView.bounds
        
        // 3. 高斯模糊
        let blurHeight: CGFloat
        if let tabBarVC = toVC as? UITabBarController {
            blurHeight = transitionView.bounds.height - tabBarVC.tabBar.bounds.height
        } else {
            blurHeight = transitionView.bounds.height
        }
        let blurEffectStartFrame = transitionView.bounds
        let blurEffectEndFrame = transitionView.bounds.setHeight(blurHeight)
        
        // 4. 内容阴影
        let contentShadowStartTransform = detailVC.detailView.contentShadowView.transform
        let contentShadowEndTransform: CGAffineTransform = .identity
        let detailContentShadowFrame = detailVC.detailView.contentShadowView.frame
        let introduceFrame = detailVC.detailView.convert(detailVC.detailView.introduceView.frame, to: detailVC.detailView.introduceView)
        detailVC.detailView.contentShadowView.transform = .identity
        
        let contentShadowStartCornerRadii = detailVC.detailView.contentShadowView.layer.cornerRadius
        let contentShadowEndCornerRadii = targetView.contentView.layer.cornerRadius
        
        let contentShadowStartFrame = detailVC.detailView.contentShadowView.convert(
            detailVC.detailView.contentShadowView.frame,
            to: detailVC.detailView
        )
        let contentShadowEndFrame = targetView.convert(targetView.bounds, to: toVC.view)
        transitionView.detailView.contentShadowView.frame = contentShadowStartFrame
        
        // 5. 内容 cover
        let contentCoverStartFrame = detailVC.detailView.coverView.convert(
            detailVC.detailView.coverView.frame,
            to: detailVC.detailView
        )
        let contentCoverEndFrame = contentShadowEndFrame.setXY(0, 0)
        transitionView.detailView.coverView.frame = contentCoverStartFrame
        
        // 6. 内容 introduce
        let offsetY = contentCoverStartFrame.minY
        let contentIntroduceStartOffset = CGPoint(
            x: 0,
            y: offsetY
        )
        let contentIntroduceEndOffset = CGPoint(
            x: introduceFrame.minX + detailContentShadowFrame.minX,
            y: offsetY + 52.0
        )
        
        // 7. mask
        let maskStartFrame = detailVC.detailView.contentView.bounds
        let maskEndFrame = targetView.bounds
        transitionView.contentMaskView.frame = maskStartFrame
        
        // 8. 关闭按钮
        let closeStartFrame = detailVC.detailView.contentView.convert(
            detailVC.detailView.closeButton.frame,
            to: detailVC.detailView.contentView
        )
        var closeEndFrame = transitionView.detailView.convert(closeStartFrame, to: targetView)
        closeEndFrame.origin.x -= (contentCoverStartFrame.maxX - contentShadowEndFrame.maxX)
        closeEndFrame = closeEndFrame.setY(closeStartFrame.minY)
        transitionView.detailView.closeButton.frame = closeStartFrame
        
        // 构造 state 的参数
        let arguments = CardTransitionState.Cover.Arguments(
            type: self.transitionType,
            duration: self.transitionDuration,
            navigationStartAlpha: navigationStartAlpha,
            navigationEndAlpha: navigationEndAlpha,
            contentShadowStartTransform: contentShadowStartTransform,
            contentShadowEndTransform: contentShadowEndTransform,
            contentShadowStartFrame: contentShadowStartFrame,
            contentShadowEndFrame: contentShadowEndFrame,
            contentShadowStartCornerRadii: contentShadowStartCornerRadii,
            contentShadowEndCornerRadii: contentShadowEndCornerRadii,
            contentMaskStartFrame: maskStartFrame,
            contentMaskEndFrame: maskEndFrame,
            contentCoverStartFrame: contentCoverStartFrame,
            contentCoverEndFrame: contentCoverEndFrame,
            contentIntroduceStartOffset: contentIntroduceStartOffset,
            contentIntroduceEndOffset: contentIntroduceEndOffset,
            closeButtonStartAlpha: detailVC.detailView.closeButton.alpha,
            closeButtonEndAlpha: 0,
            closeButtonStartFrame: closeStartFrame,
            closeButtonEndFrame: closeEndFrame
        )
        // 所有的 states
        let states = CardTransitionState.build(arguments)
        transitionView.animationViews.forEach { $0.prepareTransition(for: states) }
        
        transitionView.setNeedsLayout()
        transitionView.layoutIfNeeded()
        
        // 其它元素动画
        let dampingAnimator = UIViewPropertyAnimator(
            duration: transitionDuration,
            dampingRatio: 0.9
        )
        dampingAnimator.addAnimations {
            transitionView.immediateViews(self.transitionType).forEach {
                $0.transition(to: states)
            }
        }
        dampingAnimator.addAnimations({
            transitionView.delayeViews(self.transitionType).forEach {
                $0.transition(to: states)
            }
        }, delayFactor: 0.25)
        dampingAnimator.addCompletion { _ in
            transitionView.removeFromSuperview()
            detailVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
            // 转场结束, 展示 targetView
            targetView.isHidden = false
        }
        dampingAnimator.startAnimation()
        
        // tabBar 展示动画
        if let tabBarVC = toVC as? UITabBarController {
            transitionView.detailView.blurView.frame = blurEffectStartFrame
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: self.transitionDuration / 4,
                delay: 0,
                options: self.options,
                animations: {
                    transitionView.detailView.blurView.frame = blurEffectEndFrame
                    tabBarVC.setTabBarHidden(false)
                }
            )
        }
    }
}
