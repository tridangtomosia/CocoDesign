//
//  Font.swift
//  CoCoDesign
//
//  Created by apple on 2/22/21.
//

import SwiftUI

enum InterFont {
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
    case thin
}

extension UIFont {
    static func appFont(interFont: InterFont, size: CGFloat) -> UIFont {
        switch interFont {
        case .black:
            return UIFont(name: "Inter-Black", size: size) ?? UIFont()
        case .bold:
            return UIFont(name: "Inter-Bold", size: size) ?? UIFont()
        case .extraBold:
            return UIFont(name: "Inter-ExtraBold", size: size) ?? UIFont()
        case .extraLight:
            return UIFont(name: "Inter-Inter-ExtraLight", size: size) ?? UIFont()
        case .light:
            return UIFont(name: "Inter-Light", size: size) ?? UIFont()
        case .medium:
            return UIFont(name: "Inter-Medium", size: size) ?? UIFont()
        case .regular:
            return UIFont(name: "Inter-Regular", size: size) ?? UIFont()
        case .semiBold:
            return UIFont(name: "Inter-SemiBold", size: size) ?? UIFont()
        case .thin:
            return UIFont(name: "Inter-Thin", size: size) ?? UIFont()
        }
    }
}

extension Font {
    static func appFont(interFont: InterFont, size: CGFloat) -> Font {
        switch interFont {
        case .black:
            return Font.custom("Inter-Black", size: size)
        case .bold:
            return Font.custom("Inter-Bold", size: size)
        case .extraBold:
            return Font.custom("Inter-ExtraBold", size: size)
        case .extraLight:
            return Font.custom("Inter-Inter-ExtraLight", size: size)
        case .light:
            return Font.custom("Inter-Light", size: size)
        case .medium:
            return Font.custom("Inter-Medium", size: size)
        case .regular:
            return Font.custom("Inter-Regular", size: size)
        case .semiBold:
            return Font.custom("Inter-SemiBold", size: size)
        case .thin:
            return Font.custom("Inter-Thin", size: size)
        }
    }
}
