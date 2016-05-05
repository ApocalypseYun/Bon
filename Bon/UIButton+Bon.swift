//
//  UIButton+Bon.swift
//  Bon
//
//  Created by Chris on 16/4/24.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

private var HighlightedBackgroundColorKey = 0
private var NormalBackgroundColorKey = 0

//extension UIButton {
//    
//    @IBInspectable var highlightedBackgroundColor: UIColor? {
//        get {
//            return objc_getAssociatedObject(self, &HighlightedBackgroundColorKey) as? UIColor
//        }
//        
//        set(newValue) {
//            objc_setAssociatedObject(self,
//                                     &HighlightedBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    private var normalBackgroundColor: UIColor? {
//        get {
//            return objc_getAssociatedObject(self, &NormalBackgroundColorKey) as? UIColor
//        }
//        
//        set(newValue) {
//            objc_setAssociatedObject(self,
//                                     &NormalBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//    
//    override public var backgroundColor: UIColor? {
//        didSet {
//            if !highlighted {
//                normalBackgroundColor = backgroundColor
//            }
//        }
//    }
//    
//    override public var highlighted: Bool {
//        didSet {
//            if let highlightedBackgroundColor = self.highlightedBackgroundColor {
//                if highlighted {
//                    backgroundColor = highlightedBackgroundColor
//                } else {
//                    backgroundColor = normalBackgroundColor
//                }
//            }
//        }
//    }
//}