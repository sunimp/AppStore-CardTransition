//
//  TodayListCell.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit
import SDWebImage

final class TodayListCell: TodayCardCell {
    
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    
    let stackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var contentHeight = bounds.height - Util.marginLarge
        contentHeight -= (16.0 + Util.spacing + 28.0)
        contentHeight -= Util.marginLarge * 2
        let apps = CGFloat(stackView.arrangedSubviews.count)
        let spacings = contentHeight - apps * AppRowView.viewHeight
        stackView.spacing = spacings / max((apps - 1), 1)
    }
    
    override func setup() {
        super.setup()
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(Util.marginLarge)
            make.trailing.lessThanOrEqualToSuperview().inset(Util.marginLarge)
            make.height.equalTo(16.0)
        }
        
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Util.spacing)
            make.leading.equalToSuperview().inset(Util.marginLarge)
            make.trailing.lessThanOrEqualToSuperview().inset(Util.marginLarge)
            make.height.equalTo(28.0)
        }
        
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Util.marginLarge)
            make.leading.trailing.equalToSuperview().inset(Util.marginLarge)
            make.bottom.equalToSuperview().inset(Util.marginLarge).priority(990)
        }
    }
    
    func configure(_ event: Event, count: Int = 5) {
        titleLabel.text = event.title
        nameLabel.text = event.name
        let appViews = event.items.prefix(count).map { app in
            let appView = AppRowView()
            appView.titleLabel.textColor = .black
            appView.taglineLabel.textColor = .systemGray
            appView.actionButton.setTitleColor(.systemBlue, for: .normal)
            appView.iapLabel.textColor = .systemGray
            appView.configure(app)
            return appView
        }
        stackView.addArrangedSubviews(appViews)
    }
}
