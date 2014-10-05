//
//  Utils.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class Utils {
    
    public func blendAlpha(alphaBelow: CGFloat, alphaAbove: CGFloat) -> CGFloat {
        return alphaBelow + (1.0 - alphaBelow) * alphaAbove
    }

    public func blendColor(colorBelow: NSColor, colorAbove: NSColor) -> NSColor {
        let alphaBelow = colorBelow.alphaComponent
        let alphaAbove = colorAbove.alphaComponent
        let outAlpha = blendAlpha(alphaBelow, alphaAbove: alphaAbove)
        
        let outR = (colorBelow.redComponent * alphaBelow + colorAbove.redComponent * alphaAbove * (1 - alphaBelow)) / outAlpha
        let outG = (colorBelow.greenComponent * alphaBelow + colorAbove.greenComponent * alphaAbove * (1 - alphaBelow)) / outAlpha
        let outB = (colorBelow.blueComponent * alphaBelow + colorAbove.blueComponent * alphaAbove * (1 - alphaBelow)) / outAlpha
        
        return NSColor(calibratedRed: outR, green: outG, blue: outB, alpha: outAlpha)
    }
}