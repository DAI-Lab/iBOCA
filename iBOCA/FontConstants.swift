//
//  FontConstants.swift
//  swift-project
//
//  Created by Son Huynh on 5/24/19.
//  Copyright © 2019 Son Huynh. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Color Constants

/// All fonts define here.
public struct Font {
    
    public static func font(size: CGFloat, weight: UIFont.Weight = UIFont.Weight.regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    public static func font(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        debugPrint("Missing Font: \(name)")
        return UIFont.systemFont(ofSize: size)
    }
    
    public struct Montserrat {
        public static let blackItalic: String   = "Montserrat-BlackItalic"
        public static let black: String         = "Montserrat-Black"
        public static let boldItalic: String    = "Montserrat-BoldItalic"
        public static let bold: String          = "Montserrat-Bold"
        public static let lightItalic: String   = "Montserrat-LightItalic"
        public static let light: String         = "Montserrat-Light"
        public static let mediumItalic: String  = "Montserrat-MediumItalic"
        public static let medium: String        = "Montserrat-Medium"
        public static let regularItalic: String = "Montserrat-Italic"
        public static let regular: String       = "Montserrat-Regular"
        public static let thinItalic: String    = "Montserrat-ThinItalic"
        public static let thin: String          = "Montserrat-Thin"
        public static let semiBold: String      = "Montserrat-SemiBold"
    }
    
    public struct LucidaGrande {
        public static let bold: String          = "LucidaGrande-Bold"
    }
    
}
