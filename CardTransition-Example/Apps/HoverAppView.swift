//
//  HoverAppView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit

final class HoverAppView: UIView {
    
    static let viewHeight: CGFloat = 60.0
    static let contentInsets: UIEdgeInsets = .all(10)
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    let appView = AppRowView()
    
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        layer.cornerRadius = 14
        layer.masksToBounds = true
        
        addSubview(effectView)
        effectView.contentView.backgroundColor = .black.withAlphaComponent(0.06)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        appView.titleLabel.textColor = .black
        appView.taglineLabel.textColor = .systemGray
        appView.actionButton.setTitleColor(.systemBlue, for: .normal)
        appView.actionButton.backgroundColor = .systemGray3.withAlphaComponent(0.5)
        appView.iapLabel.textColor = .systemGray
        effectView.contentView.addSubview(appView)
        appView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Self.contentInsets)
        }
        appView.iconImageView.snp.remakeConstraints { make in
            make.size.equalTo(Self.viewHeight - Self.contentInsets.vertical)
        }
    }
    
    func configure(_ app: App) {
        appView.configure(app)
    }
}
