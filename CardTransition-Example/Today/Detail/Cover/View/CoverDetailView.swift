//
//  CoverDetailView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit

final class CoverDetailView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
    
    let contentShadowView = UIView()
    let contentView = UIView()
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    let coverView = TodayCoverView()
    let introduceView = CoverDetailIntroduceView()
    let closeButton = DetailCloseButton()
    let hoverAppView = HoverAppView()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var isHoverAppShown: Bool = false
    private var hoverAppBottomConstraint: Constraint?
    
    private let contentCornerRadii = UIScreen.main.displayCornerRadius
    
    private let scaleThresthod: CGFloat = 0.2
    private let isTransition: Bool
    
    var closeAction: (() -> Void)?
    
    init(isTransition: Bool = false) {
        self.isTransition = isTransition
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        addSubview(blurView)
        if isTransition.toggled {
            blurView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        addSubview(contentShadowView)
        contentShadowView.backgroundColor = .systemBackground
        contentShadowView.layer.shadowOffset = .zero
        contentShadowView.layer.shadowOpacity = 1
        contentShadowView.layer.shadowRadius = 12
        contentShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        if isTransition.toggled {
            contentShadowView.layer.cornerRadius = self.contentCornerRadii
            contentShadowView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        contentShadowView.addSubview(contentView)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let converHeight = (Util.screenHeight - Util.statusBarHeight) / 2 + Util.statusBarHeight
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.verticalScrollIndicatorInsets = .only(top: converHeight - Util.safeAreaInsets.top)
        scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.leading.bottom.width.equalToSuperview()
        }
        
        containerView.addSubview(introduceView)
        introduceView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(converHeight)
            make.width.equalTo(Util.screenWidth)
            make.leading.bottom.equalToSuperview()
        }
        
        contentView.addSubview(closeButton)
        if isTransition.toggled {
            closeButton.snp.makeConstraints { make in
                make.trailing.top.equalToSuperview().inset(Util.marginLarge)
                make.width.height.equalTo(26)
            }
        }
        closeButton.actionHandler = { [weak self] in
            guard let self else { return }
            
            self.closeAction?()
        }
        
        contentView.addSubview(hoverAppView)
        hoverAppView.snp.makeConstraints { make in
            hoverAppBottomConstraint = make.bottom.equalToSuperview().inset(-Util.safeAreaInsets.bottom - HoverAppView.viewHeight).constraint
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(coverView)
        if isTransition.toggled {
            coverView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(converHeight)
            }
        }
    }
    
    func configure(_ event: Event) {
        coverView.configure(event)
        introduceView.configure(event)
        if let app = event.items.first {
            hoverAppView.configure(app)
        }
        self.setNeedsLayout()
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        func reset() {
            UIView.animate(withDuration: Util.animationDuration,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.contentShadowView.transform = .identity
                self.contentShadowView.layer.cornerRadius = self.contentCornerRadii
                self.contentView.layer.cornerRadius = self.contentCornerRadii
                self.closeButton.alpha = 1
            })
        }
        
        let translation = gesture.translation(in: self)
        let direction = translation.checkScrollDirection()
        guard [.right, .down, .none].contains(direction) else {
            reset()
            return
        }
        if [.down, .none].contains(direction) {
            if scrollView.contentOffset.y > 0 {
                return
            }
        }
        
        let moveDistance = max(translation.x, translation.y)
        let distanceThresthod = self.bounds.height * self.scaleThresthod
        let scaleDelta = max(min((moveDistance / distanceThresthod), 1.0), 0)
        let scale = 1 - scaleDelta * self.scaleThresthod
        let isThresholdReached: Bool = (1 - scaleDelta) < 0.01
        let defaultRadii = self.contentCornerRadii
        let minRadii = TodayCoverCell.cornerRadius
        let radii = (defaultRadii - minRadii) * (1 - scaleDelta) + minRadii
        let alpha = 1 - scaleDelta
        switch gesture.state {
        case .began:
            break
            
        case .changed:
            
            self.contentShadowView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.contentShadowView.layer.cornerRadius = radii
            self.contentView.layer.cornerRadius = radii
            self.closeButton.alpha = alpha
            if isThresholdReached {
                self.closeAction?()
            }
            
        default:
            if isThresholdReached {
                self.closeAction?()
            } else {
                reset()
            }
        }
    }
}

extension CoverDetailView {
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let isNotOnTop = offset.y > 0
        scrollView.bounces = isNotOnTop
        scrollView.showsVerticalScrollIndicator = isNotOnTop
        
        let scrollableHeight = scrollView.contentSize.height - scrollView.bounds.height
        if offset.y > scrollableHeight * 0.3 && offset.y < scrollableHeight * 0.95 {
            showHoverApp()
        } else {
            hideHoverApp()
        }
    }
    
    private func showHoverApp() {
        guard isHoverAppShown.toggled else {
            return
        }
        isHoverAppShown = true
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut],
            animations: {
                self.hoverAppBottomConstraint?.update(inset: Util.safeAreaInsets.bottom)
                self.layoutIfNeeded()
            }
        )
    }
    
    private func hideHoverApp() {
        guard isHoverAppShown else {
            return
        }
        isHoverAppShown = false
        UIView.animate(
            withDuration: Util.animationDuration,
            delay: 0,
            options: [.curveLinear],
            animations: {
                self.hoverAppBottomConstraint?.update(inset: -Util.safeAreaInsets.bottom - HoverAppView.viewHeight)
                self.layoutIfNeeded()
            }
        )
    }
}

extension CoverDetailView {
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if self.panGestureRecognizer == gestureRecognizer,
            self.scrollView.panGestureRecognizer == otherGestureRecognizer {
            let translation = self.scrollView.panGestureRecognizer.translation(in: self)
            let direction = translation.checkScrollDirection()
            switch direction {
            case .down, .up, .left:
                return false
            
            default:
                return true
            }
        }
        return false
    }
}
