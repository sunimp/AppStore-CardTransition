//
//  TodaySupplyView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit
import SDWebImage

final class TodaySupplyView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let avatarView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.spacing = Util.spacingLarge
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Util.marginLarge)
            make.centerY.equalToSuperview()
        }
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.addArrangedSubview(titleLabel)
        
        dateLabel.textColor = .systemGray
        dateLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        stackView.addArrangedSubview(dateLabel)
        
        avatarView.layer.cornerRadius = 14
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderWidth = 0.5
        avatarView.layer.borderColor = UIColor.systemGray3.cgColor
        
        avatarView.contentMode = .scaleAspectFill
        stackView.addArrangedSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        
        configure()
    }
    
    func configure() {
        titleLabel.text = "Today"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM\u{6708}dd\u{65E5}"
        let dateText = formatter.string(from: Date())
        dateLabel.text = dateText
        avatarView.sd_setImage(with: URL(string: "https://raw.githubusercontent.com/sunimp/imgs/master/uPic/bf.png"))
    }
}
