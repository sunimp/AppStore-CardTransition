//
//  AppRowView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit
import SDWebImage

final class AppRowView: UIView {
    
    static let viewHeight: CGFloat = 48.0
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let taglineLabel = UILabel()
    
    let actionButton = UIButton()
    let iapLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        let horizontalStackView = UIStackView(frame: .zero)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = Util.spacingLarge
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.borderWidth = Util.split
        iconImageView.layer.borderColor = UIColor.systemGray3.cgColor
        iconImageView.layer.masksToBounds = true
        horizontalStackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(Self.viewHeight)
        }
     
        let verticalStackView = UIStackView(frame: .zero)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = Util.spacing
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .black
        verticalStackView.addArrangedSubview(titleLabel)
        
        taglineLabel.font = .systemFont(ofSize: 11)
        taglineLabel.textColor = .systemGray
        verticalStackView.addArrangedSubview(taglineLabel)
        
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(UIView.flexSpace(axis: .horizontal))
        
        actionButton.setTitle("查看", for: .normal)
        actionButton.setTitleColor(.systemBlue, for: .normal)
        actionButton.backgroundColor = .systemGray4.withAlphaComponent(0.5)
        actionButton.layer.cornerRadius = 15
        actionButton.layer.masksToBounds = true
        actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        actionButton.titleLabel?.textAlignment = .center
        actionButton.contentEdgeInsets = .symmetric(horizontal: 20)
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        horizontalStackView.addArrangedSubview(actionButton)
        
        iapLabel.font = .systemFont(ofSize: 7, weight: .light)
        iapLabel.textColor = .systemGray
        iapLabel.textAlignment = .center
        iapLabel.text = "App 内购买"
        addSubview(iapLabel)
        iapLabel.snp.makeConstraints { make in
            make.centerX.equalTo(actionButton)
            make.top.equalTo(actionButton.snp.bottom).offset(Util.spacing)
        }
    }
    
    @objc
    func handleAction() {
        print(#function)
    }
    
    func configure(_ app: App) {
        iconImageView.sd_setImage(with: URL(string: app.icon))
        titleLabel.text = app.name
        taglineLabel.text = app.tagline
        iapLabel.isHidden = !app.iap
    }
}
