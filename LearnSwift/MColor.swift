//
//  MColor.swift
//  LearnSwift
//

import Cocoa
import Foundation

protocol NSCoding {}

public class MColor: NSObject {
    
    public var red: Float = 0
    public var blue: Float = 0
    public var green: Float = 0
    public var alpha: Float = 1.0
    
    init(aColor: NSColor) {
        super.init()
        
        let color = aColor.colorUsingColorSpace(NSColorSpace.genericRGBColorSpace())
        
        red = Float(color.redComponent)
        blue = Float(color.blueComponent)
        green = Float(color.greenComponent)
        alpha = Float(color.alphaComponent)
    }

    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeFloat(red, forKey:"red")
        aCoder.encodeFloat(blue, forKey:"blue")
        aCoder.encodeFloat(green, forKey:"green")
        aCoder.encodeFloat(alpha, forKey:"alpha")
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init()
        
        red = aDecoder.decodeFloatForKey("red")
        blue = aDecoder.decodeFloatForKey("blue")
        green = aDecoder.decodeFloatForKey("green")
        alpha = aDecoder.decodeFloatForKey("alpha")
    }
}