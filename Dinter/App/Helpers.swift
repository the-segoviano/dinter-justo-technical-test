//
//  Helpers.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit

struct CustomGothamRoundedFont {
    
    static func getRegularFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Book", size: size)!
    }
    
    static func getLightFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Light", size: size)!
    }
    
    static func getBoldFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Bold", size: size)!
    }
    
    static func getLightFontItalic(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-LightItalic", size: size)!
    }
    
}

