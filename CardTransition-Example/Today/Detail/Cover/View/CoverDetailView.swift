//
//  CoverDetailView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit

final class CoverDetailView: DetailView<UIScrollView> {
    
    private let containerView = UIView()
    
    let coverView = TodayCoverView()
    let introduceView = CoverDetailIntroduceView()
    let hoverAppView = HoverAppView()
    
    private var isHoverAppShown: Bool = false
    private var hoverAppBottomConstraint: Constraint?
    
    override func setup() {
        super.setup()
        
        let converHeight = (Util.screenHeight - Util.statusBarHeight) / 2 + Util.statusBarHeight
        scrollView.verticalScrollIndicatorInsets = .only(top: converHeight - Util.safeAreaInsets.top)
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
    
    override func configure(_ event: Event) {
        super.configure(event)
        
        coverView.configure(event)
        introduceView.configure(event)
        if let app = event.items.first {
            hoverAppView.configure(app)
        }
        self.setNeedsLayout()
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let offsetY = scrollView.contentOffset.y
        
        let scrollableHeight = scrollView.contentSize.height - scrollView.bounds.height
        if offsetY > scrollableHeight * 0.3 && offsetY < scrollableHeight * 0.95 {
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
                self.hoverAppBottomConstraint?.update(
                    inset: -Util.safeAreaInsets.bottom - HoverAppView.viewHeight
                )
                self.layoutIfNeeded()
            }
        )
    }
}
