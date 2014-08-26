//
//  ColorRect.swift
//  LearnSwift
//
//  Created by Mady Mellor on 8/23/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa

public class ColorRect {
    
    var rect: NSRect
    var color: NSColor
    
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(color: NSColor, rect: NSRect) {
        self.color = color
        self.rect = rect
    }
    
    public func getRect() -> NSRect {
        return rect
    }
    
    public func getColor() -> NSColor {
        return color
    }
}
