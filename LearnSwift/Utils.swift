//
//  Utils.swift
//  LearnSwift
//
//  Created by Mady Mellor on 9/10/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import Foundation

public class Utils {
    
    public func blendAlpha(alphaBelow: CGFloat, alphaAbove: CGFloat) -> CGFloat {
        return alphaBelow + (1.0 - alphaBelow) * alphaAbove
    }

    public func blendColor(colorBelow: NSColor, colorAbove: NSColor) -> NSColor {
        let alphaBelow = colorBelow.alphaComponent
        let outAlpha = blendAlpha(alphaBelow, alphaAbove: colorAbove.alphaComponent)
        
        let outR = (colorBelow.redComponent * alphaBelow + colorAbove.redComponent * (1 - alphaBelow)) / outAlpha
        let outG = (colorBelow.greenComponent * alphaBelow + colorAbove.greenComponent * (1 - alphaBelow)) / outAlpha
        let outB = (colorBelow.blueComponent * alphaBelow + colorAbove.blueComponent * (1 - alphaBelow)) / outAlpha
        
        return NSColor(calibratedRed: outR, green: outG, blue: outB, alpha: outAlpha)
    }
}