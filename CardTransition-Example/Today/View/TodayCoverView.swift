//
//  TodayCoverView.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

import SnapKit
import SDWebImage

final class TodayCoverView: UIView {
    
    let coverImageView = UIImageView()
    
    let gradientView = GradientView()
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    
    let appEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
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
        
        coverImageView.contentMode = .scaleAspectFill
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Util.margin * 2)
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(Util.screenWidth)
            make.height.equalTo(Util.screenWidth * 0.4)
        }
        
        appEffectView.contentView.backgroundColor = .black.withAlphaComponent(0.25)
        addSubview(appEffectView)
        appEffectView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        appView.titleLabel.textColor = .white
        appView.taglineLabel.textColor = .white.withAlphaComponent(0.8)
        appView.actionButton.setTitleColor(.white, for: .normal)
        appView.iapLabel.textColor = .white.withAlphaComponent(0.8)
        appEffectView.contentView.addSubview(appView)
        appView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Util.marginLarge)
            make.bottom.top.equalToSuperview().inset(Util.margin)
        }
        
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(appEffectView.snp.top).offset(-Util.margin)
            make.leading.equalToSuperview().inset(Util.marginLarge)
            make.trailing.lessThanOrEqualToSuperview().inset(Util.marginLarge)
        }
        
        titleLabel.textColor = .white.withAlphaComponent(0.8)
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Util.marginLarge)
            make.trailing.lessThanOrEqualToSuperview().inset(Util.marginLarge)
            make.bottom.equalTo(nameLabel.snp.top).offset(-Util.spacing)
        }
    }
    
    func configure(_ event: Event) {
        coverImageView.sd_setImage(with: URL(string: event.cover)) { [weak self] image, _, _, _ in
            guard let image, let self else { return }
            guard let color = ColorPalette.getPalette(from: image, colorCount: 2)?.first else {
                return
            }
            let width = Util.screenWidth
            let height = width * (image.size.height / max(image.size.width, 1))
            self.coverImageView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(Util.margin * 2)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            let dominantColor = color.makeUIColor()
            self.gradientView.configure([
                (dominantColor.withAlphaComponent(0), 0),
                (dominantColor, 0.5),
                (dominantColor, 1.0)
            ], direction: .topToBottom)
        }
        titleLabel.text = event.title
        nameLabel.text = event.name
        if let app = event.items.first {
            appView.configure(app)
        }
    }
}
