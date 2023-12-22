//
//  ColorPalette.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

/// 取色器
public enum ColorPalette {
    
    /// 默认质量
    public static let defaultQuality = 10
    
    /// 默认忽略白色
    public static let defaultIgnoreWhite = true
    
    /// 获取图片的主色
    ///
    /// - Parameters:
    ///   - image: 要取色的图片
    ///   - quality: 1 是最准确的, 默认是 10
    ///              数字越大, 颜色提取的速度越快, 但获取的颜色不是视觉上看上去最主要的颜色的可能性就越大
    ///              质量和速度之间存在一定的权衡
    ///   - ignoreWhite: 是否忽略白色, true 表示忽略白色
    /// - Returns: 主色
    public static func getColor(from image: UIImage,
                                quality: Int = defaultQuality,
                                ignoreWhite: Bool = defaultIgnoreWhite) -> MMCQ.Color? {
        guard let palette = getPalette(from: image,
                                       colorCount: 5,
                                       quality: quality,
                                       ignoreWhite: ignoreWhite) else {
            return nil
        }
        let dominantColor = palette[0]
        return dominantColor
    }
    
    /// 获取图片的主要几种颜色
    ///
    /// - Parameters:
    ///   - image: 要去色的图片
    ///   - colorCount: 调色板的数量, 即返回的颜色数
    ///   - quality: 1 是最准确的, 默认是 10
    ///              数字越大, 颜色提取的速度越快, 但获取的颜色不是视觉上看上去最主要的颜色的可能性就越大
    ///              质量和速度之间存在一定的权衡
    ///   - ignoreWhite: 是否忽略白色, true 表示忽略白色
    /// - Returns: 主要的几种颜色
    public static func getPalette(from image: UIImage,
                                  colorCount: Int,
                                  quality: Int = defaultQuality,
                                  ignoreWhite: Bool = defaultIgnoreWhite) -> [MMCQ.Color]? {
        guard let colorMap = getColorMap(from: image,
                                         colorCount: colorCount,
                                         quality: quality,
                                         ignoreWhite: ignoreWhite) else {
            return nil
        }
        return colorMap.makePalette()
    }
    
    /// 获取图片中相似的几种颜色
    ///
    /// - Parameters:
    ///   - image: 要取色的图片
    ///   - colorCount: 调色板的数量, 即返回的颜色数
    ///   - quality: 1 是最准确的, 默认是 10
    ///              数字越大, 颜色提取的速度越快, 但获取的颜色不是视觉上看上去最主要的颜色的可能性就越大
    ///              质量和速度之间存在一定的权衡
    ///   - ignoreWhite: 是否忽略白色, true 表示忽略白色
    /// - Returns: 颜色图
    public static func getColorMap(from image: UIImage,
                                   colorCount: Int,
                                   quality: Int = defaultQuality,
                                   ignoreWhite: Bool = defaultIgnoreWhite) -> MMCQ.ColorMap? {
        guard let pixels = makeBytes(from: image) else {
            return nil
        }
        let colorMap = MMCQ.quantize(pixels, quality: quality, ignoreWhite: ignoreWhite, maxColors: colorCount)
        return colorMap
    }
    
    static func makeBytes(from image: UIImage) -> [UInt8]? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        if isCompatibleImage(cgImage) {
            return makeBytesFromCompatibleImage(cgImage)
        } else {
            return makeBytesFromIncompatibleImage(cgImage)
        }
    }
    
    static func isCompatibleImage(_ cgImage: CGImage) -> Bool {
        guard let colorSpace = cgImage.colorSpace else {
            return false
        }
        if colorSpace.model != .rgb {
            return false
        }
        let bitmapInfo = cgImage.bitmapInfo
        let alpha = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let alphaRequirement = (alpha == CGImageAlphaInfo.noneSkipLast.rawValue
                                || alpha == CGImageAlphaInfo.last.rawValue)
        let byteOrder = bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue
        let byteOrderRequirement = (byteOrder == CGBitmapInfo.byteOrder32Little.rawValue)
        if !(alphaRequirement && byteOrderRequirement) {
            return false
        }
        if cgImage.bitsPerComponent != 8 {
            return false
        }
        if cgImage.bitsPerPixel != 32 {
            return false
        }
        if cgImage.bytesPerRow != cgImage.width * 4 {
            return false
        }
        return true
    }
    
    static func makeBytesFromCompatibleImage(_ image: CGImage) -> [UInt8]? {
        guard let dataProvider = image.dataProvider else {
            return nil
        }
        guard let data = dataProvider.data else {
            return nil
        }
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }
    
    static func makeBytesFromIncompatibleImage(_ image: CGImage) -> [UInt8]? {
        let width = image.width
        let height = image.height
        var rawData = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return nil
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return rawData
    }
}
