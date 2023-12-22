//
//  CardTransitionView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit

final class CardCoverTransitionView: UIView {
    
    let navigationBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    let detailView = CoverDetailView(isTransition: true)
    let contentMaskView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        clipsToBounds = true
        
        detailView.blurView.clipsToBounds = true
        
        detailView.contentShadowView.stateKey = .contentShadow
        detailView.coverView.stateKey = .contentCover
        detailView.coverView.layer.masksToBounds = true
        detailView.blurView.stateKey = .blurEffect
        detailView.introduceView.stateKey = .contentIntroduce
        detailView.closeButton.stateKey = .closeButton
        detailView.contentView.stateKey = .content
        
        addSubview(detailView)
        
        contentMaskView.stateKey = .contentMask
        contentMaskView.backgroundColor = .black
        contentMaskView.layer.cornerRadius = 20
        contentMaskView.layer.masksToBounds = true
        detailView.contentView.mask = contentMaskView
        
        addSubview(navigationBar)
        navigationBar.stateKey = .navigationBar
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Util.statusBarHeight)
        }
    }
    
    func configure(_ event: Event) {
        detailView.configure(event)
    }
}

extension CardCoverTransitionView {
    
    var animationViews: [UIView] {
        [
            self.navigationBar,
            self.detailView.blurView,
            self.detailView.contentShadowView,
            self.detailView.contentView,
            self.detailView.coverView,
            self.detailView.introduceView,
            self.detailView.closeButton,
            self.contentMaskView
        ]
    }
    
    // 转场时需要立即执行动画的子视图
    func immediateViews(_ type: TransitionType) -> [UIView] {
        let delayed = delayeViews(type)
        return animationViews.filter { delayed.contains($0).toggled }
    }
    
    // 转场时需要延迟执行动画的子视图
    func delayeViews(_ type: TransitionType) -> [UIView] {
        switch type {
        case .present:
            return [self.detailView.introduceView]
        case .dismiss:
            return []
        }
    }
}
