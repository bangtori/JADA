//
//  UIColor+Extension.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/08.
//

import UIKit
extension UIColor {
    convenience init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let jadaMainGreen: UIColor = UIColor(hex: "#93C90F")
    static let jadaAlphaMainGreen: UIColor = UIColor(hex: "#93C90F", alpha: 0.5)
    static let jadaDarkGreen: UIColor = UIColor(hex: "#628709")
    static let jadaChartOrange: UIColor = UIColor(hex: "#C9680F")
    static let jadaNoteBackground: UIColor = UIColor(hex: "ECEDE5")
}
