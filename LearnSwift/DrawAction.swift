//
//  DrawAction.swift
//  LearnSwift
//
//  Created by Mady Mellor on 8/25/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import Foundation

public class DrawAction {
    
    var color: NSColor
    var brushSize: CGFloat
    var point: NSPoint
    
    init(color: NSColor, brushSize: CGFloat, point: NSPoint) {
        self.color = color
        self.brushSize = brushSize
        self.point = point
    }
    
    public func draw(initialBrushSize: CGFloat) {
        // Determine x and y to draw.
        var x = point.x
        var y = point.y
        
        var lx = x - (x % initialBrushSize)
        var ly = y - (y % initialBrushSize)
        var r = NSMakeRect(lx, ly, brushSize, brushSize)
        
        color.setFill()
        NSRectFill(r)
    }
}