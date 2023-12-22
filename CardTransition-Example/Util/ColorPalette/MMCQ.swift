//
//  MMCQ.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

/// MMCQ (Modified Median Cut Quantization) 中值切割量化算法
/// 具体见 Leptonica (http://www.leptonica.com/)
public enum MMCQ {
    
    /// 颜色定义
    public struct Color {
        
        /// 红色
        public var red: UInt8 = 0
        /// 绿色
        public var green: UInt8 = 0
        /// 蓝色
        public var blue: UInt8 = 0
        
        /// 色相 Hue [0...360.0)
        public var hue: CGFloat = 0
        /// 饱和度 Saturation [0...1.0]
        public var saturation: CGFloat = 0
        /// 亮度 Lightness [0...1.0]
        public var lightness: CGFloat = 0
        
        init(red: UInt8, green: UInt8, blue: UInt8) {
            self.red = red
            self.green = green
            self.blue = blue
            
            let (hue, saturation, luma) = toHSL()
            
            self.hue = hue
            self.saturation = saturation
            self.lightness = luma
        }
        
        init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
            self.hue = hue
            self.saturation = saturation
            self.lightness = lightness
            
            let uiColor = UIColor(hue: hue / 360.0,
                                  saturation: saturation,
                                  brightness: lightness,
                                  alpha: 1.0)
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            red = max(min(1.0, red), 0)
            green = max(min(1.0, green), 0)
            blue = max(min(1.0, blue), 0)
       
            self.red = UInt8(red.float * 255.0)
            self.green = UInt8(green.float * 255.0)
            self.blue = UInt8(blue.float * 255.0)
        }
        
        /// 生成 UIColor
        public func makeUIColor() -> UIColor {
            return UIColor(displayP3Red: CGFloat(red) / 255.0,
                           green: CGFloat(green) / 255.0,
                           blue: CGFloat(blue) / 255.0,
                           alpha: 1.0)
        }
        
        /// 根据当前色调生成码点颜色
        /// - Parameters:
        ///   - lightness: 亮度值
        /// - Returns: 颜色
        public func makeCodePointColor(luma: CGFloat = 0.15) -> Color {
            let candidateColor = Color(hue: self.hue,
                                       saturation: self.saturation,
                                       lightness: luma)
            
            return candidateColor
        }
        
        /// 根据当前色调生成衍生色调
        /// - Parameters:
        ///   - step: 色相步长
        ///   - count: 颜色数量
        /// - Returns: 颜色数组
        public func makeDerivativeColors(by step: CGFloat = 7.0, count: Int = 4) -> [Color] {
            guard step > 0, count > 1 else { return [] }
            
            var median = count / 2
            var derivativeColors: [Color] = []
            for index in 0..<median {
                if hue - step * CGFloat(index + 1) < 0 {
                    median = index
                    break
                }
                if hue + step * CGFloat(index + 1) > 360 {
                    median = count - index
                    break
                }
            }
            
            let dominantHue = hue
            let dominantSaturation = saturation
            let dominantLuma = lightness
            
            for index in 0..<median {
                let candidateHue = dominantHue - step * CGFloat(index + 1)
                let candidateColor = Color(hue: candidateHue,
                                           saturation: dominantSaturation,
                                           lightness: dominantLuma)
                derivativeColors.append(candidateColor)
            }
            
            let largeRange = count - median
            for index in 0..<largeRange {
                let candidateHue = dominantHue + step * CGFloat(index + 1)
                let candidateColor = Color(hue: candidateHue,
                                           saturation: dominantSaturation,
                                           lightness: dominantLuma)
                derivativeColors.append(candidateColor)
            }
            
            return derivativeColors
        }
        
        private func toHSL() -> (hue: CGFloat, saturation: CGFloat, luma: CGFloat) {
            
            let redFloat: CGFloat = CGFloat(red) / 255.0
            let greenFloat: CGFloat = CGFloat(green) / 255.0
            let blueFloat: CGFloat = CGFloat(blue) / 255.0
            
            let max: CGFloat = max(redFloat, greenFloat, blueFloat)
            let min: CGFloat = min(redFloat, greenFloat, blueFloat)
            
            // hue 0...360.0
            var hue: CGFloat = 0
            if max == min {
                hue = 0.0
            } else if max == redFloat && greenFloat >= blueFloat {
                hue = 60 * (greenFloat - blueFloat) / (max - min)
            } else if max == redFloat && greenFloat < blueFloat {
                hue = 60 * (greenFloat - blueFloat) / (max - min) + 360.0
            } else if max == greenFloat {
                hue = 60 * (blueFloat - redFloat) / (max - min) + 120.0
            } else if max == blueFloat {
                hue = 60 * (redFloat - greenFloat) / (max - min) + 240.0
            }
            
            // lightness 0...1.0
            let luma: CGFloat = (redFloat + greenFloat + blueFloat) / 3.0
            
            // saturation 0...1.0
            var saturation: CGFloat = 0
            if luma == 0 || max == min {
                saturation = 0
            } else if luma > 0 && luma <= 0.5 {
                saturation = (max - min) / (2 * luma)
            } else if luma > 0.5 {
                saturation = (max - min) / (2.0 - 2 * luma)
            }
            
            return (hue, saturation, luma)
        }
    }
    
    /// 色彩通道
    enum ColorChannel {
        case red
        case green
        case blue
    }
    
    /// 3D 色彩 Box
    class VBox {
        
        var rMin: UInt8
        var rMax: UInt8
        var gMin: UInt8
        var gMax: UInt8
        var bMin: UInt8
        var bMax: UInt8
        
        private let histogram: [Int]
        
        private var average: Color?
        private var volume: Int?
        private var count: Int?
        
        init(rMin: UInt8, rMax: UInt8, gMin: UInt8, gMax: UInt8, bMin: UInt8, bMax: UInt8, histogram: [Int]) {
            self.rMin = rMin
            self.rMax = rMax
            self.gMin = gMin
            self.gMax = gMax
            self.bMin = bMin
            self.bMax = bMax
            self.histogram = histogram
        }
        
        init(vbox: VBox) {
            self.rMin = vbox.rMin
            self.rMax = vbox.rMax
            self.gMin = vbox.gMin
            self.gMax = vbox.gMax
            self.bMin = vbox.bMin
            self.bMax = vbox.bMax
            self.histogram = vbox.histogram
        }
        
        func makeRange(min: UInt8, max: UInt8) -> CountableRange<Int> {
            if min <= max {
                return Int(min) ..< Int(max + 1)
            } else {
                return Int(max) ..< Int(max)
            }
        }
        
        var rRange: CountableRange<Int> { return makeRange(min: rMin, max: rMax) }
        var gRange: CountableRange<Int> { return makeRange(min: gMin, max: gMax) }
        var bRange: CountableRange<Int> { return makeRange(min: bMin, max: bMax) }
        
        /// 获取色彩空间的 3 维体积
        ///
        /// - Parameter force: 是否强制重算
        /// - Returns: 体积
        func getVolume(forceRecalculate force: Bool = false) -> Int {
            if let volume = volume, !force {
                return volume
            } else {
                let volume = (Int(rMax) - Int(rMin) + 1) * (Int(gMax) - Int(gMin) + 1) * (Int(bMax) - Int(bMin) + 1)
                self.volume = volume
                return volume
            }
        }
        
        /// 获取直方图采样的总数
        ///
        /// - Parameter force: 是否强制重算
        /// - Returns: 总数
        func getCount(forceRecalculate force: Bool = false) -> Int {
            if let count = count, !force {
                return count
            } else {
                var count = 0
                for redIndex in rRange {
                    for greenIndex in gRange {
                        for blueIndex in bRange {
                            let index = MMCQ.makeColorIndexOf(red: redIndex, green: greenIndex, blue: blueIndex)
                            count += histogram[index]
                        }
                    }
                }
                self.count = count
                return count
            }
        }
        
        /// 获取平均色
        ///
        /// - Parameter force: 是否强制重算
        /// - Returns: 平均色
        func getAverage(forceRecalculate force: Bool = false) -> Color {
            if let average = average, !force {
                return average
            } else {
                var ntot = 0
                
                var rSum = 0
                var gSum = 0
                var bSum = 0
                
                for redIndex in rRange {
                    for greenIndex in gRange {
                        for blueIndex in bRange {
                            let index = MMCQ.makeColorIndexOf(red: redIndex, green: greenIndex, blue: blueIndex)
                            let hval = histogram[index]
                            ntot += hval
                            rSum += Int(Double(hval) * (Double(redIndex) + 0.5) * Double(MMCQ.multiplier))
                            gSum += Int(Double(hval) * (Double(greenIndex) + 0.5) * Double(MMCQ.multiplier))
                            bSum += Int(Double(hval) * (Double(blueIndex) + 0.5) * Double(MMCQ.multiplier))
                        }
                    }
                }
                
                let average: Color
                if ntot > 0 {
                    let red = UInt8(rSum / ntot)
                    let green = UInt8(gSum / ntot)
                    let blue = UInt8(bSum / ntot)
                    average = Color(red: red, green: green, blue: blue)
                } else {
                    let red = UInt8(min(MMCQ.multiplier * (Int(rMin) + Int(rMax) + 1) / 2, 255))
                    let green = UInt8(min(MMCQ.multiplier * (Int(gMin) + Int(gMax) + 1) / 2, 255))
                    let blue = UInt8(min(MMCQ.multiplier * (Int(bMin) + Int(bMax) + 1) / 2, 255))
                    average = Color(red: red, green: green, blue: blue)
                }
                
                self.average = average
                return average
            }
        }
        
        func widestColorChannel() -> ColorChannel {
            let rWidth = rMax - rMin
            let gWidth = gMax - gMin
            let bWidth = bMax - bMin
            switch max(rWidth, gWidth, bWidth) {
            case rWidth:
                return .red
            case gWidth:
                return .green
            default:
                return .blue
            }
        }
        
    }
    
    /// 色彩图
    public class ColorMap {
        
        var vboxes = [VBox]()
        
        func push(_ vbox: VBox) {
            vboxes.append(vbox)
        }
        
        /// 生成调色板
        public func makePalette() -> [Color] {
            return vboxes.map { $0.getAverage() }
        }
        
        /// 生成最接近的颜色
        public func makeNearestColor(to color: Color) -> Color {
            var nearestDistance = Int.max
            var nearestColor = Color(red: 0, green: 0, blue: 0)
            
            for vbox in vboxes {
                let vbColor = vbox.getAverage()
                let dr = abs(Int(color.red) - Int(vbColor.red))
                let dg = abs(Int(color.green) - Int(vbColor.green))
                let db = abs(Int(color.blue) - Int(vbColor.blue))
                let distance = dr + dg + db
                if distance < nearestDistance {
                    nearestDistance = distance
                    nearestColor = vbColor
                }
            }
            
            return nearestColor
        }
    }
    
    // 仅使用 8 位的高 5 位
    private static let signalBits = 5
    private static let rightShift = 8 - signalBits
    private static let multiplier = 1 << rightShift
    private static let histogramSize = 1 << (3 * signalBits)
    private static let vboxLength = 1 << signalBits
    private static let fractionByPopulation = 0.75
    private static let maxIterations = 1_000
    
    /// 获取一个像素在 RGB 色彩空间的颜色索引
    ///
    /// - Parameters:
    ///   - red: 红色值
    ///   - green: 绿色值
    ///   - blue: 蓝色值
    /// - Returns: 颜色索引
    static func makeColorIndexOf(red: Int, green: Int, blue: Int) -> Int {
        return (red << (2 * signalBits)) + (green << signalBits) + blue
    }
    
    /// 生成一维数组
    /// 给出色彩空间的每个量化区域中的像素数
    /// 当初错误时为空
    private static func makeHistogramAndVBox(from pixels: [UInt8], quality: Int, ignoreWhite: Bool) -> ([Int], VBox) {
        var histogram = [Int](repeating: 0, count: histogramSize)
        var rMin = UInt8.max
        var rMax = UInt8.min
        var gMin = UInt8.max
        var gMax = UInt8.min
        var bMin = UInt8.max
        var bMax = UInt8.min
        
        let pixelCount = pixels.count / 4
        for step in stride(from: 0, to: pixelCount, by: quality) {
            let alpha = pixels[step * 4 + 0]
            let blue = pixels[step * 4 + 1]
            let green = pixels[step * 4 + 2]
            let red = pixels[step * 4 + 3]
            
            // 如果像素大部分是透明或白色
            guard alpha >= 125 && !(ignoreWhite && red > 250 && green > 250 && blue > 250) else {
                continue
            }
            
            let shiftedR = red >> UInt8(rightShift)
            let shiftedG = green >> UInt8(rightShift)
            let shiftedB = blue >> UInt8(rightShift)
            
            // min/max
            rMin = min(rMin, shiftedR)
            rMax = max(rMax, shiftedR)
            gMin = min(gMin, shiftedG)
            gMax = max(gMax, shiftedG)
            bMin = min(bMin, shiftedB)
            bMax = max(bMax, shiftedB)
            
            // 修改直方图的值
            let index = Self.makeColorIndexOf(red: Int(shiftedR), green: Int(shiftedG), blue: Int(shiftedB))
            histogram[index] += 1
        }
        
        let vbox = VBox(rMin: rMin, rMax: rMax, gMin: gMin, gMax: gMax, bMin: bMin, bMax: bMax, histogram: histogram)
        return (histogram, vbox)
    }
    
    private static func applyMedianCut(with histogram: [Int], vbox: VBox) -> [VBox] {
        guard vbox.getCount() != 0 else {
            return []
        }
        
        // 只有一个像素时, 不需要分割
        guard vbox.getCount() != 1 else {
            return [vbox]
        }
        
        // 沿选定色彩通道查找[局部和]数组
        var total = 0
        var partialSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0
        
        let axis = vbox.widestColorChannel()
        switch axis {
        case .red:
            for redIndex in vbox.rRange {
                var sum = 0
                for greenIndex in vbox.gRange {
                    for blueIndex in vbox.bRange {
                        let index = Self.makeColorIndexOf(red: redIndex, green: greenIndex, blue: blueIndex)
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[redIndex] = total
            }
        case .green:
            for greenIndex in vbox.gRange {
                var sum = 0
                for redIndex in vbox.rRange {
                    for blueIndex in vbox.bRange {
                        let index = Self.makeColorIndexOf(red: redIndex, green: greenIndex, blue: blueIndex)
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[greenIndex] = total
            }
        case .blue:
            for blueIndex in vbox.bRange {
                var sum = 0
                for redIndex in vbox.rRange {
                    for greenIndex in vbox.gRange {
                        let index = Self.makeColorIndexOf(red: redIndex, green: greenIndex, blue: blueIndex)
                        sum += histogram[index]
                    }
                }
                total += sum
                partialSum[blueIndex] = total
            }
        }
        
        var lookAheadSum = [Int](repeating: -1, count: vboxLength) // -1 = not set / 0 = 0
        for (idx, sum) in partialSum.enumerated() where sum != -1 {
            lookAheadSum[idx] = total - sum
        }
        
        return cut(by: axis, vbox: vbox, partialSum: partialSum, lookAheadSum: lookAheadSum, total: total)
    }
    
    private static func cut(by axis: ColorChannel,
                            vbox: VBox,
                            partialSum: [Int],
                            lookAheadSum: [Int],
                            total: Int) -> [VBox] {
        let vboxMin: Int
        let vboxMax: Int
        
        switch axis {
        case .red:
            vboxMin = Int(vbox.rMin)
            vboxMax = Int(vbox.rMax)
        case .green:
            vboxMin = Int(vbox.gMin)
            vboxMax = Int(vbox.gMax)
        case .blue:
            vboxMin = Int(vbox.bMin)
            vboxMax = Int(vbox.bMax)
        }
        
        for index in vboxMin...vboxMax where partialSum[index] > total / 2 {
            let vbox1 = VBox(vbox: vbox)
            let vbox2 = VBox(vbox: vbox)
            
            let left = index - vboxMin
            let right = vboxMax - index
            
            var d2: Int
            if left <= right {
                d2 = min(vboxMax - 1, index + right / 2)
            } else {
                // 强转成 Int
                d2 = max(vboxMin, Int(Double(index - 1) - Double(left) / 2.0))
            }
            
            // 避免出现 0 次
            while d2 < 0 || partialSum[d2] <= 0 {
                d2 += 1
            }
            var count2 = lookAheadSum[d2]
            while count2 == 0 && d2 > 0 && partialSum[d2 - 1] > 0 {
                d2 -= 1
                count2 = lookAheadSum[d2]
            }
            
            // 设置尺寸
            switch axis {
            case .red:
                vbox1.rMax = UInt8(d2)
                vbox2.rMin = UInt8(d2 + 1)
            case .green:
                vbox1.gMax = UInt8(d2)
                vbox2.gMin = UInt8(d2 + 1)
            case .blue:
                vbox1.bMax = UInt8(d2)
                vbox2.bMin = UInt8(d2 + 1)
            }
            
            return [vbox1, vbox2]
        }
        
        debugPrint("VBox can't be cut")
        return []
    }
    
    /// 量化色值
    static func quantize(_ pixels: [UInt8], quality: Int, ignoreWhite: Bool, maxColors: Int) -> ColorMap? {
        // 短路
        guard pixels.isNotEmpty && maxColors > 1 && maxColors <= 256 else {
            return nil
        }
        
        // 从像素中获取颜色的直方图和
        let (histogram, vbox) = makeHistogramAndVBox(from: pixels, quality: quality, ignoreWhite: ignoreWhite)
        
        // 优先级队列
        var pq = [vbox]
        
        // 向上取整
        let target = Int(ceil(fractionByPopulation * Double(maxColors)))
        
        // 第一组颜色，按比例排序
        iterate(over: &pq, comparator: compareByCount, target: target, histogram: histogram)
        
        // 按像素占用 * 颜色空间大小的乘积重新排序
        pq.sort(by: compareByProduct)
        
        // 使用 (npix * vol) 排序生成的中位数切割
        iterate(over: &pq, comparator: compareByProduct, target: maxColors - pq.count, histogram: histogram)
        
        // 翻转队列, 将最多的颜色首先放入色图中
        pq = pq.reversed()
        
        let colorMap = ColorMap()
        pq.forEach { colorMap.push($0) }
        return colorMap
    }
    
    private static func iterate(over queue: inout [VBox],
                                comparator: (VBox, VBox) -> Bool,
                                target: Int,
                                histogram: [Int]) {
        var color: Int = 1
        
        for _ in 0 ..< maxIterations {
            guard let vbox = queue.last else {
                return
            }
            
            if vbox.getCount() == 0 {
                queue.sort(by: comparator)
                continue
            }
            queue.removeLast()
            
            // 切割
            let vboxes = applyMedianCut(with: histogram, vbox: vbox)
            queue.append(vboxes[0])
            if vboxes.count == 2 {
                queue.append(vboxes[1])
                color += 1
            }
            queue.sort(by: comparator)
            
            if color >= target {
                return
            }
        }
    }
    
    private static func compareByCount(_ lhs: VBox, _ rhs: VBox) -> Bool {
        return lhs.getCount() < rhs.getCount()
    }
    
    private static func compareByProduct(_ lhs: VBox, _ rhs: VBox) -> Bool {
        let lhsCount = lhs.getCount()
        let rhsCount = rhs.getCount()
        let lhsVolume = lhs.getVolume()
        let rhsVolume = rhs.getVolume()
        
        if lhsCount == rhsCount {
            // 如果两者色值计数相等, 按体积排序
            return lhsVolume < rhsVolume
        } else {
            // 否则按乘积排序
            let lhsProduct = Int64(lhsCount) * Int64(lhsVolume)
            let rhsProduct = Int64(rhsCount) * Int64(rhsVolume)
            return lhsProduct < rhsProduct
        }
    }
    
}
