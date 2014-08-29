//
//  Grid.swift
//  LearnSwift
//
//  Created by Mady Mellor on 8/28/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import Foundation

public class Grid: NSView {
    
    // User specified options
    var canvasColor: NSColor
    var selectedColor: NSColor
    var brushSize: CGFloat
    
    // Grid config
    var width: CGFloat
    var height: CGFloat
    var squareSize: CGFloat
    
    // Drawing state
    var grid: [[ColorState]]
    var drawRecords: [DrawRecord]
    
    required public init(coder: NSCoder) {
        // TODO -- Not sure why this is needed? Swift / cocoa thing?
        fatalError("NSCoding not supported")
    }
    
    init(frame: NSRect, width: CGFloat, height: CGFloat, squareSize: CGFloat) {
        // User specified options (we set reasonable defaults)
        self.canvasColor = NSColor.whiteColor()
        self.selectedColor = NSColor.blueColor()
        self.brushSize = 1
        
        // Grid config
        self.width = width
        self.height = height
        self.squareSize = squareSize
        
        // Drawing state
        self.drawRecords = []
        self.grid =
            Array(count: Int(width), repeatedValue: Array(count: Int(height), repeatedValue: ColorState()))
        
        // NSView
        super.init(frame: frame)
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Draw the last square.
        if (!drawRecords.isEmpty) {
            var dr = drawRecords.last!
            var x = Int(dr.getFirstPoint().x)
            var y = Int(dr.getFirstPoint().y)
            var andSize = CGFloat(dr.getSize())
            var withColor = grid[x][y].getColor()
            
            // Draw the square.
            var r = NSMakeRect(CGFloat(x), CGFloat(y), squareSize*andSize, squareSize*andSize)
            withColor!.setFill()
            NSRectFill(r)
        }
    }
    
    //
    // Adds a square to the grid.
    //
    public func addSquare(atPoint: NSPoint, withColor: NSColor, andSize: Int) {
        var point = convertPointToGrid(atPoint)
        var x = Int(point.x)
        var y = Int(point.y)
        
        // Color the necessary squares.
        var addedSize = andSize
        for (var i = x; i < x + addedSize; i++) {
            for (var j = y; j < y + addedSize; j++) {
                
                // Take care of state.
                var colorState = grid[i][j]
                colorState.addColor(withColor)
            }
        }
        
        // Update the drawing records
        drawRecords.append(DrawRecord(firstPoint: point, size: andSize))
        
        // Let the view know to draw.
        var size = CGFloat(andSize) * squareSize
        var r = NSMakeRect(point.x, point.y, size, size)
        setNeedsDisplayInRect(r)
    }

    //
    // Takes a point on the screen and determines the point on the grid.
    //
    private func convertPointToGrid(point: NSPoint) -> NSPoint {
        var x = point.x
        var y = point.y
        
        // Get the points locked to grid size.
        var lx = min(x - (x % squareSize), width - squareSize)
        var ly = min(y - (y % squareSize), height - squareSize)
        lx = max(lx, 0)
        ly = max(ly, 0)
        return NSPoint(x: lx, y: ly)
    }
    
    
    //
    // Set attributes.
    //
    
    public func setColour(color: NSColor) {
        selectedColor = color
    }
    
    public func setCanvasColour(color: NSColor) {
        canvasColor = color
        needsDisplay = true
    }
    
    public func setBrushSize(size: CGFloat) {
        if (gridSize == -1) {
            gridSize = size
        }
        brushSize = size
    }
    
    //
    // Handling drawing input.
    //
    
    override public func mouseDown(theEvent: NSEvent!) {
        super.mouseDown(theEvent)
        var point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(point, withColor: selectedColor, andSize: Int(brushSize))
    }
    
    override public func mouseDragged(theEvent: NSEvent!) {
        super.mouseDragged(theEvent)
        var point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(point, withColor: selectedColor, andSize: Int(brushSize))
    }
    
    //
    // Undo / redo / clear.
    //
    
    public func removeLastRect(goBackBy: NSInteger) {
        // TODO
    }
    
    public func readdRect(goBackBy: NSInteger) {
        // TODO
    }
    
    public func clearScreen() {
        
        needsDisplay = true
    }
    
    //
    // Save screen.
    //
    
    public func saveScreen(url: NSURL!) {
        var beautifulArtwork = self.bitmapImageRepForCachingDisplayInRect(self.bounds)
        self.cacheDisplayInRect(self.bounds, toBitmapImageRep: beautifulArtwork!)
        var data = beautifulArtwork!.TIFFRepresentation
        var nsData = NSData.self.dataWithData(data)
        nsData.writeToFile(url.path, atomically: false)
    }
}