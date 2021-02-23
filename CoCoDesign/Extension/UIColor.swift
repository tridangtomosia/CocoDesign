/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        func transform(_ input: Int, offset: Int = 0) -> CGFloat {
            let value = (input >> offset) & 0xFF
            return CGFloat(value) / 255
        }

        self.init(red: transform(hex, offset: 16),
                  green: transform(hex, offset: 8),
                  blue: transform(hex),
                  alpha: alpha)
    }

    class func rgb(red: Int, green: Int, blue: Int) -> UIColor {
        return rgbA(red: red, green: green, blue: blue, alpha: 1)
    }

    class func rgbA(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: alpha)
    }

    class func hex(_ hex: String?, alpha: CGFloat = 1) -> UIColor {
        guard let hex = hex else { return .clear }
        let hexInt = UIColor.intFromHex(hex)
        let color = UIColor(red: (CGFloat)((hexInt & 0xFF0000) >> 16) / 255,
                            green: (CGFloat)((hexInt & 0xFF00) >> 8) / 255,
                            blue: (CGFloat)(hexInt & 0xFF) / 255,
                            alpha: alpha)
        return color
    }

    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        setFill()
        ctx?.fillPath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }

    private class func intFromHex(_ hex: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

    func isDistinct(compare color: UIColor) -> Bool {
        guard let mainComponents = cgColor.components,
            let compareComponents = color.cgColor.components else { return false }
        let threshold: CGFloat = 0.25

        if abs(mainComponents[0] - compareComponents[0]) > threshold ||
            abs(mainComponents[1] - compareComponents[1]) > threshold ||
            abs(mainComponents[2] - compareComponents[2]) > threshold {
            if abs(mainComponents[0] - mainComponents[1]) < 0.03 && abs(compareComponents[0] - compareComponents[2]) < 0.03 {
                if abs(compareComponents[0] - compareComponents[1]) < 0.03 && abs(compareComponents[0] - compareComponents[2]) < 0.03 {
                    return false
                }
            }
            return true
        }
        return false
    }

    func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}
