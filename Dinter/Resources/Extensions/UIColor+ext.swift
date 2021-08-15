//
//  UIColor+ext.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit

extension UIColor {
    
    static let greenCustomized = ParseColor.hexStringToUIColor(hex: "#21b384")
    
}

class ParseColor {
    /**
     * Metodo para crear un color a partir de un hexadecimal en String
     *
     * @param hex String que se convertira a UIColor
     * @return UIColor
     */
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
