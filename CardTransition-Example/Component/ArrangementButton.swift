//
//  ArrangementButton.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/20.
//

import UIKit

// swiftlint:disable file_length
/// 图片和文字不同方式排列的按钮
open class ArrangementButton: UIButton {
    
    public enum ImagePosition {
        case top, left, bottom, right
    }
    
    // 按钮图标和文字的相对位置
    public var imagePosition: ImagePosition = .left {
        didSet {
            setNeedsLayout()
        }
    }
    
    // 按钮图标和文字之间的间隔, 响应 imagePosition 的变化而变化
    public var spacingBetweenImageAndTitle: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 直接访问 self.imageView 会触发 layoutSubviews
    private var _imageView: UIImageView? {
        let _imageView_ = perform(NSSelectorFromString("_imageView")).takeUnretainedValue()
        if let imageView = _imageView_ as? UIImageView {
            return imageView
        }
        return nil
    }
    
    public init(position: ImagePosition, spacing: CGFloat) {
        
        self.imagePosition = position
        self.spacingBetweenImageAndTitle = spacing
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        
        contentEdgeInsets = UIEdgeInsets(
            top: .leastNormalMagnitude,
            left: 0,
            bottom: .leastNormalMagnitude,
            right: 0
        )
    }
    
    // overrides
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = size
        if bounds.size == size {
            newSize = CGSize(width: .max, height: .max)
        }
        
        let isImageViewShowing = currentImage != nil
        let isTitleLabelShowing = currentTitle != nil || currentAttributedTitle != nil
        
        var imageTotalSize: CGSize = .zero // 包含 imageEdgeInsets 的空间
        var titleTotalSize: CGSize = .zero // 包含 titleEdgeInsets 的空间
        // 如果图片或文字某一者没显示, 则 spacing 不考虑进布局
        let spacingBetweenImageAndTitle: CGFloat = isImageViewShowing && isTitleLabelShowing ? self
            .spacingBetweenImageAndTitle.flat : 0
        
        let contentEdgeInsets = self.contentEdgeInsets.removeFloatMin
        var resultSize: CGSize = .zero
        let contentLimitSize = CGSize(
            width: newSize.width - contentEdgeInsets.horizontal,
            height: newSize.height - contentEdgeInsets.vertical
        )
        
        switch imagePosition {
        case .top, .bottom:
            // 图片和文字上下排版时
            // 宽度以文字或图片的最大宽度为最终宽度
            if isImageViewShowing {
                let imageLimitWidth = contentLimitSize.width - imageEdgeInsets.horizontal
                var imageSize: CGSize = .zero
                if let imageView = imageView, imageView.image != nil {
                    imageSize = imageView
                        .sizeThatFits(CGSize(
                            width: imageLimitWidth,
                            height: .greatestFiniteMagnitude
                        ))
                } else {
                    if let currentImage = currentImage {
                        imageSize = currentImage.size
                    }
                }
                
                imageSize.width = .minimum(imageSize.width, imageLimitWidth)
                imageTotalSize = CGSize(
                    width: imageSize.width + imageEdgeInsets.horizontal,
                    height: imageSize.height + imageEdgeInsets.vertical
                )
                
                if isTitleLabelShowing {
                    let titleLimitSize = CGSize(
                        width: contentLimitSize.width - titleEdgeInsets.horizontal,
                        height: contentLimitSize.height - imageTotalSize
                            .height - spacingBetweenImageAndTitle - titleEdgeInsets.vertical
                    )
                    
                    var titleSize: CGSize = .zero
                    if let titleLabel = titleLabel {
                        titleSize = titleLabel.sizeThatFits(titleLimitSize)
                    }
                    titleSize.height = .minimum(titleSize.height, titleLimitSize.height)
                    titleTotalSize = CGSize(
                        width: titleSize.width + titleEdgeInsets.horizontal,
                        height: titleSize.height + titleEdgeInsets.vertical
                    )
                }
                
                resultSize.width = contentEdgeInsets.horizontal
                resultSize.width += .maximum(imageTotalSize.width, titleTotalSize.width)
                resultSize.height = contentEdgeInsets.vertical + imageTotalSize
                    .height + spacingBetweenImageAndTitle + titleTotalSize.height
            }
            
        case .left, .right:
            // 图片和文字水平排版时
            // 高度以文字或图片的最大高度为最终高度
            // 当 titleLabel 为多行时, sizeThatFits: 计算结果固定是单行的
            // 在 imagePosition 为.left 并且 titleLabel 多行的情况下，特殊计算
            if isImageViewShowing {
                let imageLimitHeight = contentLimitSize.height - imageEdgeInsets.vertical
                var imageSize: CGSize = .zero
                if let imageView = imageView, imageView.image != nil {
                    imageSize = imageView
                        .sizeThatFits(CGSize(
                            width: .greatestFiniteMagnitude,
                            height: imageLimitHeight
                        ))
                } else {
                    if let currentImage = currentImage {
                        imageSize = currentImage.size
                    }
                }
                imageSize.height = .minimum(imageSize.height, imageLimitHeight)
                imageTotalSize = CGSize(
                    width: imageSize.width + imageEdgeInsets.horizontal,
                    height: imageSize.height + imageEdgeInsets.vertical
                )
            }
            
            if isTitleLabelShowing {
                let titleLimitSize = CGSize(
                    width: contentLimitSize.width - titleEdgeInsets.horizontal - imageTotalSize
                        .width - spacingBetweenImageAndTitle,
                    height: contentLimitSize.height - titleEdgeInsets.vertical
                )
                var titleSize: CGSize = .zero
                if let label = titleLabel {
                    titleSize = label.sizeThatFits(titleLimitSize)
                }
                titleSize.height = .minimum(titleSize.height, titleLimitSize.height)
                titleTotalSize = CGSize(
                    width: titleSize.width + titleEdgeInsets.horizontal,
                    height: titleSize.height + titleEdgeInsets.vertical
                )
            }
            
            resultSize.width = contentEdgeInsets.horizontal + imageTotalSize
                .width + spacingBetweenImageAndTitle + titleTotalSize.width
            resultSize.height = contentEdgeInsets.vertical
            resultSize.height += .maximum(imageTotalSize.height, titleTotalSize.height)
        }
        
        return resultSize
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: .max, height: .max))
    }
    
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !bounds.isEmpty else { return }
        
        let isImageViewShowing = currentImage != nil
        let isTitleLabelShowing = currentTitle != nil || currentAttributedTitle != nil
        
        var imageLimitSize: CGSize = .zero
        var titleLimitSize: CGSize = .zero
        var imageTotalSize: CGSize = .zero // 包含 imageEdgeInsets 的空间
        var titleTotalSize: CGSize = .zero // 包含 titleEdgeInsets 空间
        // 如果图片或文字某一者没显示，则 spacing 不考虑进布局
        let spacingBetweenImageAndTitle: CGFloat = (isImageViewShowing && isTitleLabelShowing) ?
        self.spacingBetweenImageAndTitle.flat : 0
        
        var imageFrame: CGRect = .zero
        var titleFrame: CGRect = .zero
        let contentEdgeInsets = self.contentEdgeInsets.removeFloatMin
        let contentSize = CGSize(
            width: bounds.width - contentEdgeInsets.horizontal,
            height: bounds.height - contentEdgeInsets.vertical
        )
        
        if isImageViewShowing {
            imageLimitSize = CGSize(
                width: contentSize.width - imageEdgeInsets.horizontal,
                height: contentSize.height - imageEdgeInsets.vertical
            )
            var imageSize: CGSize = .zero
            if let imageView = _imageView, imageView.image != nil {
                imageSize = imageView.sizeThatFits(imageLimitSize)
            } else {
                if let currentImage = currentImage {
                    imageSize = currentImage.size
                }
            }
            imageSize.width = .minimum(imageLimitSize.width, imageSize.width)
            imageSize.height = .minimum(imageLimitSize.height, imageSize.height)
            imageFrame = CGRect(origin: .zero, size: imageSize)
            imageTotalSize = CGSize(
                width: imageSize.width + imageEdgeInsets.horizontal,
                height: imageSize.height + imageEdgeInsets.vertical
            )
        }
        
        let ensureBoundsPositive: (UIView) -> Void = { view in
            var viewBounds = view.bounds
            if viewBounds.minX < 0 || viewBounds.minY < 0 {
                viewBounds = CGRect(origin: .zero, size: viewBounds.size)
                view.bounds = viewBounds
            }
        }
        
        if isImageViewShowing {
            if let imageView = _imageView {
                ensureBoundsPositive(imageView)
            }
        }
        
        if isTitleLabelShowing {
            if let label = titleLabel {
                ensureBoundsPositive(label)
            }
        }
        
        // 图片上下排版
        if imagePosition == .top || imagePosition == .bottom {
            if isTitleLabelShowing {
                titleLimitSize = CGSize(
                    width: contentSize.width - titleEdgeInsets.horizontal,
                    height: contentSize.height - imageTotalSize
                        .height - spacingBetweenImageAndTitle - titleEdgeInsets.vertical
                )
                var titleSize: CGSize = .zero
                if let label = titleLabel {
                    titleSize = label.sizeThatFits(titleLimitSize)
                }
                titleSize.width = .minimum(titleLimitSize.width, titleSize.width)
                titleSize.height = .minimum(titleLimitSize.height, titleSize.height)
                titleFrame = CGRect(origin: .zero, size: titleSize)
                titleTotalSize = CGSize(
                    width: titleSize.width + titleEdgeInsets.horizontal,
                    height: titleSize.height + titleEdgeInsets.vertical
                )
            }
            
            switch contentHorizontalAlignment {
            case .left:
                imageFrame = isImageViewShowing ? imageFrame
                    .setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setX(contentEdgeInsets.left + titleEdgeInsets.left) : titleFrame
            case .center:
                imageFrame = isImageViewShowing ? imageFrame
                    .setX(
                        contentEdgeInsets.left + imageEdgeInsets.left + imageLimitSize.width
                            .centre(imageFrame.width)
                    ) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setX(
                        contentEdgeInsets.left + titleEdgeInsets.left + titleLimitSize.width
                            .centre(titleFrame.width)
                    ) : titleFrame
            case .right:
                imageFrame = isImageViewShowing ? imageFrame
                    .setX(
                        bounds.width - contentEdgeInsets.right - imageEdgeInsets
                            .right - imageFrame.width
                    ) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setX(
                        bounds.width - contentEdgeInsets.right - titleEdgeInsets
                            .right - titleFrame.width
                    ) : titleFrame
            case .fill:
                if isImageViewShowing {
                    imageFrame = imageFrame.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                    imageFrame = imageFrame.setWidth(imageLimitSize.width)
                }
                
                if isTitleLabelShowing {
                    titleFrame = titleFrame.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                    titleFrame = titleFrame.setWidth(titleLimitSize.width)
                }
            default: break
            }
            
            if case .top = imagePosition {
                switch contentVerticalAlignment {
                case .top:
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(
                            contentEdgeInsets.top + imageTotalSize
                                .height + spacingBetweenImageAndTitle + titleEdgeInsets.top
                        ) : titleFrame
                case .center:
                    let contentHeight = imageTotalSize
                        .height + spacingBetweenImageAndTitle + titleTotalSize.height
                    let minY = contentSize.height.centre(contentHeight) + contentEdgeInsets.top
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(minY + imageEdgeInsets.top) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(
                            minY + imageTotalSize
                                .height + spacingBetweenImageAndTitle + titleEdgeInsets.top
                        ) : titleFrame
                case .bottom:
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(
                            bounds.height - contentEdgeInsets.bottom - titleEdgeInsets
                                .bottom - titleFrame.height
                        ) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(
                            bounds.height - contentEdgeInsets.bottom - titleTotalSize
                                .height - spacingBetweenImageAndTitle - imageEdgeInsets
                                .bottom - imageFrame
                                .height
                        ) : imageFrame
                case .fill:
                    if isImageViewShowing, isTitleLabelShowing {
                        imageFrame = isImageViewShowing ? imageFrame
                            .setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setY(
                                contentEdgeInsets.top + imageTotalSize
                                    .height + spacingBetweenImageAndTitle + titleEdgeInsets.top
                            ) :
                        titleFrame
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setHeight(
                                bounds.height - contentEdgeInsets.bottom - titleEdgeInsets
                                    .bottom - titleFrame.minY
                            ) : titleFrame
                    }
                default: break
                }
            } else {
                switch contentVerticalAlignment {
                case .top:
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(contentEdgeInsets.top + titleEdgeInsets.top) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(
                            contentEdgeInsets.top + titleTotalSize
                                .height + spacingBetweenImageAndTitle + imageEdgeInsets.top
                        ) : imageFrame
                case .center:
                    let contentHeight = imageTotalSize.height + titleTotalSize
                        .height + spacingBetweenImageAndTitle
                    let minY = contentSize.height.centre(contentHeight) + contentEdgeInsets.top
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(minY + titleEdgeInsets.top) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(
                            minY + titleTotalSize
                                .height + spacingBetweenImageAndTitle + imageEdgeInsets.top
                        ) : imageFrame
                case .bottom:
                    imageFrame = isImageViewShowing ? imageFrame
                        .setY(
                            bounds.height - contentEdgeInsets.bottom - imageEdgeInsets
                                .bottom - imageFrame.height
                        ) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setY(
                            bounds.height - contentEdgeInsets.bottom - imageTotalSize
                                .height - spacingBetweenImageAndTitle - titleEdgeInsets
                                .bottom - titleFrame
                                .height
                        ) : titleFrame
                case .fill:
                    if isImageViewShowing, isTitleLabelShowing {
                        imageFrame = imageFrame
                            .setY(
                                bounds.height - contentEdgeInsets.bottom - imageEdgeInsets
                                    .bottom - imageFrame.height
                            )
                        titleFrame = titleFrame.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                        titleFrame = titleFrame
                            .setHeight(
                                bounds.height - contentEdgeInsets.bottom - imageTotalSize
                                    .height - spacingBetweenImageAndTitle - titleEdgeInsets
                                    .bottom - titleFrame.minY
                            )
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.setY(contentEdgeInsets.top + imageEdgeInsets.top)
                        imageFrame = imageFrame
                            .setHeight(contentSize.height - imageEdgeInsets.vertical)
                    } else {
                        titleFrame = titleFrame.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                        titleFrame = titleFrame
                            .setHeight(contentSize.height - titleEdgeInsets.vertical)
                    }
                default: break
                }
            }
            
            if isImageViewShowing {
                _imageView?.frame = imageFrame.flatted
            }
            
            if isTitleLabelShowing {
                titleLabel?.frame = titleFrame.flatted
            }
            // 图片左右排版
        } else if imagePosition == .left || imagePosition == .right {
            
            if isTitleLabelShowing {
                titleLimitSize = CGSize(
                    width: contentSize.width - titleEdgeInsets.horizontal - imageTotalSize
                        .width - spacingBetweenImageAndTitle,
                    height: contentSize.height - titleEdgeInsets.vertical
                )
                var titleSize: CGSize = .zero
                if let label = titleLabel {
                    titleSize = label.sizeThatFits(titleLimitSize)
                }
                titleSize.width = .minimum(titleLimitSize.width, titleSize.width)
                titleSize.height = .minimum(titleLimitSize.height, titleSize.height)
                titleFrame = CGRect(origin: .zero, size: titleSize)
                titleTotalSize = CGSize(
                    width: titleSize.width + titleEdgeInsets.horizontal,
                    height: titleSize.height + titleEdgeInsets.vertical
                )
            }
            
            switch contentVerticalAlignment {
            case .top:
                imageFrame = isImageViewShowing ? imageFrame
                    .setY(contentEdgeInsets.top + imageEdgeInsets.top) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setY(contentEdgeInsets.top + titleEdgeInsets.top) : titleFrame
            case .center:
                imageFrame = isImageViewShowing ? imageFrame
                    .setY(
                        contentEdgeInsets.top + contentSize.height
                            .centre(imageFrame.height) + imageEdgeInsets.top
                    ) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setY(
                        contentEdgeInsets.top + contentSize.height
                            .centre(titleFrame.height) + titleEdgeInsets.top
                    ) : titleFrame
            case .bottom:
                imageFrame = isImageViewShowing ? imageFrame
                    .setY(
                        bounds.height - contentEdgeInsets.bottom - imageEdgeInsets
                            .bottom - imageFrame.height
                    ) : imageFrame
                titleFrame = isTitleLabelShowing ? titleFrame
                    .setY(
                        bounds.height - contentEdgeInsets.bottom - titleEdgeInsets
                            .bottom - titleFrame.height
                    ) : titleFrame
            case .fill:
                if isImageViewShowing {
                    imageFrame = imageFrame.setY(contentEdgeInsets.top + imageEdgeInsets.top)
                    imageFrame = imageFrame.setHeight(contentSize.height - imageEdgeInsets.vertical)
                }
                if isTitleLabelShowing {
                    titleFrame = titleFrame.setY(contentEdgeInsets.top + titleEdgeInsets.top)
                    titleFrame = titleFrame.setHeight(contentSize.height - titleEdgeInsets.vertical)
                }
            default: break
            }
            
            if case .left = imagePosition {
                switch contentHorizontalAlignment {
                case .left:
                    imageFrame = isImageViewShowing ? imageFrame
                        .setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setX(
                            contentEdgeInsets.left + imageTotalSize
                                .width + spacingBetweenImageAndTitle + titleEdgeInsets.left
                        ) : titleFrame
                case .center:
                    let contentWidth = imageTotalSize
                        .width + spacingBetweenImageAndTitle + titleTotalSize.width
                    let minX = contentEdgeInsets.left + contentSize.width.centre(contentWidth)
                    imageFrame = isImageViewShowing ? imageFrame
                        .setX(minX + imageEdgeInsets.left) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setX(
                            minX + imageTotalSize
                                .width + spacingBetweenImageAndTitle + titleEdgeInsets.left
                        ) : titleFrame
                case .right:
                    if imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize
                        .width > contentSize.width
                    {
                        imageFrame = isImageViewShowing ? imageFrame
                            .setX(contentEdgeInsets.left + imageEdgeInsets.left) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setX(
                                contentEdgeInsets.left + imageTotalSize
                                    .width + spacingBetweenImageAndTitle + titleEdgeInsets.left
                            ) :
                        titleFrame
                    } else {
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setX(
                                bounds.width - contentEdgeInsets.right - titleEdgeInsets
                                    .right - titleFrame.width
                            ) : titleFrame
                        imageFrame = isImageViewShowing ? imageFrame
                            .setX(
                                bounds.width - contentEdgeInsets.right - titleTotalSize
                                    .width - spacingBetweenImageAndTitle - imageTotalSize
                                    .width + imageEdgeInsets.left
                            ) : imageFrame
                    }
                case .fill:
                    if isImageViewShowing, isTitleLabelShowing {
                        imageFrame = imageFrame.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        titleFrame = titleFrame
                            .setX(
                                contentEdgeInsets.left + imageTotalSize
                                    .width + spacingBetweenImageAndTitle + titleEdgeInsets.left
                            )
                        titleFrame = titleFrame
                            .setWidth(
                                bounds.width - contentEdgeInsets.right - titleEdgeInsets
                                    .right - titleFrame.minX
                            )
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        imageFrame = imageFrame
                            .setWidth(contentSize.width - imageEdgeInsets.horizontal)
                    } else {
                        titleFrame = titleFrame.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame
                            .setWidth(contentSize.width - titleEdgeInsets.horizontal)
                    }
                default: break
                }
            } else {
                switch contentHorizontalAlignment {
                case .left:
                    if imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize
                        .width > contentSize.width
                    {
                        imageFrame = isImageViewShowing ? imageFrame
                            .setX(
                                bounds.width - contentEdgeInsets.right - imageEdgeInsets
                                    .right - imageFrame.width
                            ) : imageFrame
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setX(
                                bounds.width - contentEdgeInsets.right - imageTotalSize
                                    .width - spacingBetweenImageAndTitle - titleTotalSize
                                    .width + titleEdgeInsets.left
                            ) : titleFrame
                    } else {
                        titleFrame = isTitleLabelShowing ? titleFrame
                            .setX(contentEdgeInsets.left + titleEdgeInsets.left) : titleFrame
                        imageFrame = isImageViewShowing ? imageFrame
                            .setX(
                                contentEdgeInsets.left + titleTotalSize
                                    .width + spacingBetweenImageAndTitle + imageEdgeInsets.left
                            ) :
                        imageFrame
                    }
                case .center:
                    let contentWidth = imageTotalSize
                        .width + spacingBetweenImageAndTitle + titleTotalSize.width
                    let minX = contentEdgeInsets.left + contentSize.width.centre(contentWidth)
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setX(minX + titleEdgeInsets.left) : titleFrame
                    imageFrame = isImageViewShowing ? imageFrame
                        .setX(
                            minX + titleTotalSize
                                .width + spacingBetweenImageAndTitle + imageEdgeInsets.left
                        ) : imageFrame
                case .right:
                    imageFrame = isImageViewShowing ? imageFrame
                        .setX(
                            bounds.width - contentEdgeInsets.right - imageEdgeInsets
                                .right - imageFrame.width
                        ) : imageFrame
                    titleFrame = isTitleLabelShowing ? titleFrame
                        .setX(
                            bounds.width - contentEdgeInsets.right - imageTotalSize
                                .width - spacingBetweenImageAndTitle - titleEdgeInsets
                                .right - titleFrame
                                .width
                        ) : titleFrame
                case .fill:
                    if isImageViewShowing, isTitleLabelShowing {
                        imageFrame = imageFrame
                            .setX(
                                bounds.width - contentEdgeInsets.right - imageEdgeInsets
                                    .right - imageFrame.width
                            )
                        titleFrame = titleFrame.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame
                            .setWidth(
                                imageFrame.minX - imageEdgeInsets
                                    .left - spacingBetweenImageAndTitle - titleEdgeInsets
                                    .right - titleFrame
                                    .minX
                            )
                    } else if isImageViewShowing {
                        imageFrame = imageFrame.setX(contentEdgeInsets.left + imageEdgeInsets.left)
                        imageFrame = imageFrame
                            .setWidth(contentSize.width - imageEdgeInsets.horizontal)
                    } else {
                        titleFrame = titleFrame.setX(contentEdgeInsets.left + titleEdgeInsets.left)
                        titleFrame = titleFrame
                            .setWidth(contentSize.width - titleEdgeInsets.horizontal)
                    }
                default: break
                }
            }
            
            if isImageViewShowing {
                _imageView?.frame = imageFrame.flatted
            }
            
            if isTitleLabelShowing {
                titleLabel?.frame = titleFrame.flatted
            }
        }
    }
}
