//
//  Help.swift
//  CoCoDesign
//
//  Created by apple on 2/2/21.
//
import UIKit
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    struct AppColor {
        static let appColor = Color(hex: "#34ADB1")
        static let grayBorderColor = Color(hex: "#D0DBEA")
        static let textPlaceHolder = Color(hex: "#E1E1E1")
        static let grayTextColor = Color(hex: "#9FA5C0")
        static let blueLinkColor = Color(hex: "#005CF5")
        static let blackColor = Color(hex: "#2E3E5C")
        static let grayBoldColor = Color(hex: "#D2D2D2")
        static let shadowColor = Color(hex: "#000000").opacity(0.18)
        static let backgroundColor = Color(hex: "#F4F5F7")
    }
}
