//
//  DetailCloseButton.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit

final class DetailCloseButton: UIControl {
    
    private let iconView = UIImageView()
    
    var actionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        self.layer.masksToBounds = true
    }
    
    private func setup() {
        
        backgroundColor = .white
        
        self.addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
        iconView.image = UIImage(systemName: "xmark.circle.fill")?.make(
            .black.withAlphaComponent(0.7),
            size: CGSize(width: 30, height: 30)
        )
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(-2)
        }
    }
    
    @objc
    private func handleTouchUpInside() {
        actionHandler?()
    }
}
