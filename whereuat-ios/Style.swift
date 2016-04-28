//
//  Style.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/29/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import RandomColorSwift

extension UIColor {
    // UIColor is extended to include a hex constructor
    convenience init(hex : Int) {
        let blue = CGFloat(hex & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let red = CGFloat((hex >> 16) & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}

/*
 * ColorWheel represents the color palette used for whereu@
 */
struct ColorWheel {
    
    static let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    static let lightGray = UIColor(hex: 0xF8F7F3)
    static let darkGray = UIColor(hex: 0x979797)
    static let coolRed = UIColor(hex: 0xF15369)
    static let offBlack = UIColor(hex: 0x101820)
    static let offWhite = UIColor(hex: 0xFAFAFA)
    
    static func randomColor() -> UIColor {
        return RandomColorSwift.randomColor(hue: .Random, luminosity: .Bright)
    }
}

/*
 * FontStyle represents the font styles used for whereu@
 * Font sizes are scaled according to the display
 */
struct FontStyle {
    static let h1 = UIFont(name: "Lato-Semibold", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 75)
    static let h2 = UIFont(name: "Lato-Semibold", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 150)
    static let h3 = UIFont(name: "Lato-Semibold", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 200)
    static let h4 = UIFont(name: "Lato-Bold", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 240)
    static let h5 = UIFont(name: "Lato-Bold", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 280)
    static let p = UIFont(name: "Lato-Regular", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 280)
    static let small = UIFont(name: "Lato-Light", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 320)
    static let smallLight = UIFont(name: "Lato-Thin", size: UIFont.systemFontSize() * UIScreen.mainScreen().bounds.width / 320)
    
}

/*
 * Shape draws shapes needed for whereu@
 */
struct Shape {
    /*
     * drawStar draws a star
     * @param bounds - the CGRect to draw in
     * @param width - the width of the star
     * @param height - the height of the star
     * @param borderColor - the color of the start to draw
     * @param fillColor - the color of the fill to draw
     */
    static func drawStar(bounds: CGRect , _ width: CGFloat, _ height: CGFloat, _ borderColor: UIColor, _ fillColor: UIColor) -> CAShapeLayer {
        let path = CGPathCreateMutable()
        
        // X and Y coordinates for the bottom of the top point on the star.
        let neckY: CGFloat = 0.34
        let neckX: CGFloat = 0.656
        // Y coordinate for the point of the left point of the star.
        let armY: CGFloat = 0.393
        // X and Y coordinates for the bottom of the left point of the star.
        let pitY: CGFloat = 0.648
        let pitX: CGFloat = 0.753
        // Y coordinate for the crease between the bottom two points on the star.
        let crotchY: CGFloat = 0.834
        // X coordinate for the bottom left point on the star.
        let footX: CGFloat = 0.807
        let mid: CGFloat = 0.5
        
        CGPathMoveToPoint(path, nil, mid*width, 0)
        CGPathAddLineToPoint(path, nil, neckX * width, neckY * height)
        CGPathAddLineToPoint(path, nil, width, armY * height)
        CGPathAddLineToPoint(path, nil, pitX * width, pitY * height)
        CGPathAddLineToPoint(path, nil, footX * width, height)
        
        CGPathAddLineToPoint(path, nil, mid * width, crotchY * height)
        
        // Draw the right side, starting at the crotch and going counter-clockwise to the top point.
        CGPathAddLineToPoint(path, nil, (1-footX) * width, height)
        CGPathAddLineToPoint(path, nil, (1-pitX) * width, pitY * height)
        CGPathAddLineToPoint(path, nil, 0, armY * height)
        CGPathAddLineToPoint(path, nil, (1-neckX) * width, neckY * height)
        
        CGPathAddLineToPoint(path, nil, mid * width, 0)
        
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
    static let halfSpacingMargin = CGFloat(5)
    static let quarterSpacingMargin = CGFloat(2.5)
}