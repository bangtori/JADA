//
//  UIFont+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit

extension UIFont {
    /// size: 24 (bold)
    static var jadaLargeTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    /// size: 20 (bold)
    static var jadaTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    /// size: 17 (medium)
    static var jadaBodyFont: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    /// size: 17 (Bold)
    static var jadaBoldBodyFont: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    /// size: 14 (medium)
    static var jadaCalloutFont: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    /// size: 45 (bold)
    static var jadaAnalyticsFont: UIFont {
        return UIFont.systemFont(ofSize: 45, weight: .bold)
    }
}
