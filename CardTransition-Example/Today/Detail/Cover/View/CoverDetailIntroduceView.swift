//
//  CoverDetailIntroduceView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit
import SDWebImage

final class CoverDetailIntroduceView: UIView {
    
    private let contentStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ event: Event) {
        self.contentStackView.removeAllArrangedSubviews()
        var contentViews: [UIView] = []
        if let introduce = event.introduce {
            if let title = introduce.title, title.isNotEmpty {
                contentViews.append(TextLabel(content: title, isTitle: true))
            }
            for content in introduce.contents {
                switch content.type {
                case .text:
                    contentViews.append(TextLabel(content: content.value))
                case .image:
                    contentViews.append(ImageView(url: content.value))
                }
            }
        }
        if let app = event.items.first {
            let appView = AppView()
            appView.configure(app)
            contentViews.append(appView)
        }
        if contentViews.isNotEmpty {
            self.contentStackView.addArrangedSubviews(contentViews)
        }
    }
}

extension CoverDetailIntroduceView {
    
    private class TextLabel: UILabel {
        
        private let content: String
        private let textInsets: UIEdgeInsets
        private lazy var separator = UIView()
        
        private let isTitle: Bool
        
        init(
            content: String,
            isTitle: Bool = false
        ) {
            self.content = content
            self.isTitle = isTitle
            
            if isTitle {
                self.textInsets = .all(Util.marginLarge)
            } else {
                self.textInsets = .only(
                    top: Util.marginLarge,
                    left: Util.marginLarge,
                    right: Util.marginLarge
                )
            }
            
            super.init(frame: .zero)
            
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: textInsets))
        }
        
        override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            let insets = self.textInsets
            var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
            rect.origin.x -= insets.left
            rect.origin.y -= insets.top
            rect.size.width += insets.horizontal
            rect.size.height += insets.vertical
            return rect
        }
        
        private func setup() {
            numberOfLines = 0
            
            if isTitle {
                attributedText = content.attributedString(
                    font: .systemFont(ofSize: 15, weight: .semibold),
                    color: .black,
                    lineSpacing: 6
                )
                separator.backgroundColor = .separator
                addSubview(separator)
                separator.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(textInsets)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(Util.split)
                }
            } else {
                attributedText = content.attributedString(
                    font: .systemFont(ofSize: 15),
                    color: .systemGray,
                    lineSpacing: 6
                )
            }
        }
    }
    
    private class ImageView: UIView {
        
        private let imageView = UIImageView()
        
        private let url: String
        
        init(url: String) {
            self.url = url
            super.init(frame: .zero)
            
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: URL(string: url)) { [weak self] image, _, _, _ in
                guard let self, let image else { return }
                
                let ratio = image.size.height / max(1, image.size.width)
                self.imageView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(Util.marginLarge)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(self.imageView.snp.width).multipliedBy(ratio)
                    make.bottom.equalToSuperview().priority(900)
                }
            }
        }
    }
    
    private class AppView: UIView {
        
        let contentView = UIView()
        let iconImageView = UIImageView()
        let titleLabel = UILabel()
        let taglineLabel = UILabel()
        
        let actionButton = UIButton()
        let iapLabel = UILabel()
        
        let shareButton = ArrangementButton(position: .left, spacing: 6)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
        }
        
        @available(*, unavailable)
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            
            backgroundColor = .systemBackground
            
            contentView.backgroundColor = .systemGray6
            addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Util.marginLarge)
                make.leading.trailing.equalToSuperview()
            }
            
            iconImageView.layer.cornerRadius = 16
            iconImageView.layer.borderWidth = Util.split
            iconImageView.layer.borderColor = UIColor.systemGray3.cgColor
            iconImageView.layer.masksToBounds = true
            iconImageView.snp.makeConstraints { make in
                make.size.equalTo(64)
            }
            
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            titleLabel.textColor = .black
            
            taglineLabel.font = .systemFont(ofSize: 13)
            taglineLabel.numberOfLines = 0
            taglineLabel.textColor = .systemGray
            
            actionButton.setTitle("查看", for: .normal)
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.backgroundColor = .systemBlue
            actionButton.layer.cornerRadius = 15
            actionButton.layer.masksToBounds = true
            actionButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            actionButton.titleLabel?.textAlignment = .center
            actionButton.contentEdgeInsets = .symmetric(horizontal: Util.marginLarge)
            actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
            actionButton.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
            
            iapLabel.font = .systemFont(ofSize: 7, weight: .light)
            iapLabel.textColor = .systemGray
            iapLabel.textAlignment = .center
            iapLabel.text = "App 内购买"
            
            let stack = VStack(distribution: .fill, alignment: .center, spacing: Util.spacingLarge) {
                iconImageView
                titleLabel
                taglineLabel
                actionButton
                iapLabel
            }
            
            contentView.addSubview(stack)
            stack.setCustomSpacing(Util.marginLarge, after: taglineLabel)
            stack.setCustomSpacing(Util.spacing, after: actionButton)
            
            stack.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(Util.marginLarge)
            }
            
            shareButton.setImage(
                UIImage(systemName: "square.and.arrow.up")?.make(.systemBlue, size: CGSize(width: 16, height: 18.8)),
                for: .normal
            )
            shareButton.setTitle("分享", for: .normal)
            shareButton.setTitleColor(.systemBlue, for: .normal)
            shareButton.backgroundColor = .systemGray6
            shareButton.layer.cornerRadius = 8
            shareButton.layer.masksToBounds = true
            shareButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            shareButton.contentEdgeInsets = .symmetric(horizontal: Util.margin * 2)
            shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
            addSubview(shareButton)
            shareButton.snp.makeConstraints { make in
                make.top.equalTo(stack.snp.bottom).offset(Util.marginLarge * 4)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(Util.marginLarge * 3 + Util.safeAreaInsets.bottom)
                make.height.equalTo(44)
            }
        }
        
        @objc
        func handleAction() {
            print(#function)
        }
        
        @objc
        func handleShare() {
            print(#function)
        }
        
        func configure(_ app: App) {
            iconImageView.sd_setImage(with: URL(string: app.icon))
            titleLabel.text = app.name
            taglineLabel.text = app.tagline
            iapLabel.isHidden = !app.iap
        }
    }

}
