//
//  UIColor+Bon.swift
//  Bon
//
//  Created by Chris on 16/4/20.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

extension UIColor {
    class func bonTintColor() -> UIColor {
        return UIColor(red: 148/255.0, green: 141/255.0, blue: 157/255.0, alpha: 1.0)
    }
    
    // Inverse color
    var bon_inverseColor: UIColor {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
    
    // Binary color
    var bon_binaryColor: UIColor {
        
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        
        return white > 0.92 ? UIColor.blackColor() : UIColor.whiteColor()
    }

}