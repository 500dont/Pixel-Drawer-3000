//
//  MColor.swift
//  LearnSwift
//

import Cocoa
import Foundation

protocol NSCoding {}

// TODO - possibly convert GridModel to be based on this rather than NSColor?
public class MColor: NSObject {
    
    // Indiates if the color is a background color or not, if it's a background color
    // we don't care about.
    public var isBackground: Bool = false
    
    // If we have a color these values will be updated.
    public var red: Float = 0
    public var blue: Float = 0
    public var green: Float = 0
    public var alpha: Float = 1.0
    
    init(aColor: NSColor?) {
        super.init()
        
        if let color = aColor {
            let color = color.colorUsingColorSpace(NSColorSpace.genericRGBColorSpace())
            red = Float(color.redComponent)
            blue = Float(color.blueComponent)
            green = Float(color.greenComponent)
            alpha = Float(color.alphaComponent)
        } else {
            isBackground = true
        }
    }

    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeBool(isBackground, forKey: "isBackground")
        aCoder.encodeFloat(red, forKey:"red")
        aCoder.encodeFloat(blue, forKey:"blue")
        aCoder.encodeFloat(green, forKey:"green")
        aCoder.encodeFloat(alpha, forKey:"alpha")
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init()
        isBackground = aDecoder.decodeBoolForKey("isBackground")
        red = aDecoder.decodeFloatForKey("red")
        blue = aDecoder.decodeFloatForKey("blue")
        green = aDecoder.decodeFloatForKey("green")
        alpha = aDecoder.decodeFloatForKey("alpha")
    }
}