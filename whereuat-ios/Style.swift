//
//  Style.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/29/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex : Int) {
        let blue = CGFloat(hex & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let red = CGFloat((hex >> 16) & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}

struct ColorWheel {
    
    static let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    static let lightGray = UIColor(hex: 0xF8F7F3)
    static let darkGray = UIColor(hex: 0x979797)
    static let coolRed = UIColor(hex: 0xF15369)
    static let offBlack = UIColor(hex: 0x101820)
    static let offWhite = UIColor(hex: 0xFAFAFA)
    
    static func randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

struct FontStyle {
    
    static let h1 = UIFont(name: "Lato-Semibold", size: 80)
    static let h2 = UIFont(name: "Lato-Semibold", size: 40)
    static let h3 = UIFont(name: "Lato-Semibold", size: 30)
    static let h4 = UIFont(name: "Lato-Bold", size: 24)
    static let h5 = UIFont(name: "Lato-Bold", size: 18)
    static let p = UIFont(name: "Lato-Regular", size: 18)
    static let small = UIFont(name: "Lato-Light", size: 16)
    static let smallLight = UIFont(name: "Lato-Thin", size: 16)
    
}

struct Shape {
    static func drawStar(bounds: CGRect , _ width: CGFloat, _ height: CGFloat, _ borderColor: UIColor, _ fillColor: UIColor) -> CAShapeLayer {
        let path = CGPathCreateMutable()
        
        let yOffset = 0.1*height
        CGPathMoveToPoint(path, nil, 0.5*width, 0.0*height + yOffset)
        
        CGPathAddLineToPoint(path, nil, 0.7*width, 0.31*height + yOffset)
        CGPathAddLineToPoint(path, nil, 1.0*width, 0.39*height + yOffset)
        CGPathAddLineToPoint(path, nil, 0.8*width, 0.7*height + yOffset)
        CGPathAddLineToPoint(path, nil, 0.86*width, 1.0*height + yOffset)
        
        CGPathAddLineToPoint(path, nil, 0.5*width, 0.87*height + yOffset)
        
        CGPathAddLineToPoint(path, nil, 0.14*width, 1.0*height + yOffset)
        CGPathAddLineToPoint(path, nil, 0.20*width, 0.7*height + yOffset)
        CGPathAddLineToPoint(path, nil, 0.0*width, 0.39*height + yOffset)
        CGPathAddLineToPoint(path, nil, 0.30*width, 0.31*height + yOffset)
        
        CGPathAddLineToPoint(path, nil, 0.5*width, 0.0*height + yOffset)
        
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = path
        shape.lineWidth = 1.0
        shape.strokeColor = borderColor.CGColor
        shape.fillColor = fillColor.CGColor
        return shape
    }

}

struct SizingConstants {
    static let spacingMargin = CGFloat(10)
}