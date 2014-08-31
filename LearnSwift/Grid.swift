//
//  Grid.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class Grid: NSView {
    
    var canvasColor: NSColor
    var selectedColor: NSColor
    var brushSize: CGFloat
    
    var width: CGFloat
    var height: CGFloat
    var squareSize: CGFloat
    
    var drawRecords: [DrawRecord]
    var undoRecords: [DrawRecord]
    var grid: [[ColorState?]]
    
    var drawAll: Bool
    
    required public init(coder: NSCoder) {
        // TODO -- Not sure why this is needed? Swift / cocoa thing?
        fatalError("NSCoding not supported")
    }
    
    override init(frame: NSRect) {
        self.drawAll = true
        self.canvasColor = NSColor.whiteColor()
        self.selectedColor = NSColor.blueColor()
        self.brushSize = 1
        
        self.width = frame.width
        self.height = frame.height
        self.squareSize = 10
        
        self.drawRecords = []
        self.undoRecords = []
        self.grid = Array(count: Int(width), repeatedValue: Array(count: Int(height), repeatedValue: nil))
        
        super.init(frame: frame)
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if (drawAll) {
            canvasColor.setFill()
            NSRectFill(self.bounds)
            
            for (var i = 0; i < drawRecords.count; i++) {
                var dr = drawRecords[i]
                drawSquare(dr.getFirstPoint(), size: CGFloat(dr.getSize()))
            }
            drawAll = false
            
        } else if (!drawRecords.isEmpty) {
            // Draw the last square added to drawRecords.
            var dr = drawRecords.last!
            drawSquare(dr.getFirstPoint(), size: CGFloat(dr.getSize()))
        }
    }
    
    //
    // Handling grid and draw state.
    //
    
    private func drawSquare(point: NSPoint, size: CGFloat) {
        var x = Int(point.x)
        var y = Int(point.y)
        var andSize = size
        var withColor = grid[x][y]?.getColor()

        let s = squareSize * andSize
        var r = NSMakeRect(CGFloat(x), CGFloat(y), s, s)
        withColor!.setFill()
        NSRectFill(r)
    }
    
    private func addSquare(atPoint: NSPoint, withColor: NSColor, andSize: Int) {
        var point = convertToGridPoint(atPoint)
        var x = Int(point.x)
        var y = Int(point.y)
        
        // Set the color in necessary squares.
        var addedSize = andSize
        for (var i = x; i < x + addedSize; i++) {
            for (var j = y; j < y + addedSize; j++) {
                if let colorState = grid[i][j] {
                    colorState.addColor(withColor)
                } else {
                    var cs = ColorState(color: withColor)
                    grid[i][j] = cs
                }
            }
        }
        
        // Update the drawing records.
        drawRecords.append(DrawRecord(firstPoint: point, size: andSize))
        
        // Let the view know to draw.
        var size = CGFloat(andSize) * squareSize
        var r = NSMakeRect(point.x, point.y, size, size)
        setNeedsDisplayInRect(r)
    }
    
    private func convertToGridPoint(point: NSPoint) -> NSPoint {
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
    
    public func undo(goBackBy: NSInteger) {
        // 1. Move the color pointer back on necessary tiles.
        
        // 2. Indicate those tiles should be redrawn.
    }
    
    public func redo(goBackBy: NSInteger) {
        // TODO
    }
    
    public func clearScreen() {
        undoRecords = drawRecords.reverse()
        drawRecords = []
        drawAll = true
        needsDisplay = true
    }
    
    //
    // Set user specified options.
    //
    
    public func setColour(color: NSColor) {
        selectedColor = color
    }
    
    public func setCanvasColour(color: NSColor) {
        canvasColor = color
        drawAll = true
        needsDisplay = true
    }
    
    public func setBrushSize(size: CGFloat) {
        brushSize = size
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
    
    //
    // Best debug function ever.
    //
    public func printGrid() {
        var colorInt = 0
        var prevColors = [NSColor: Int]()
        var stringArray = [String]()
        for (var i = 0; i < Int(width); i++) {
            var rowString = "row " + i.description + ": "
            for (var j = 0; j < Int(height); j++) {
                if let colorState = grid[i][j] {
                    if let c = colorState.getColor() {
                        if let thisColor = prevColors[c] {
                            rowString += "[" + thisColor.description + "]"
                        } else {
                            prevColors[c] = colorInt
                            colorInt += 1
                            rowString += "[" + colorInt.description + "]"
                        }
                    } else {
                        rowString += "[_]"
                    }
                } else {
                    rowString += "[_]"
                }
            }
            rowString += "\n"
            stringArray.append(rowString)
            rowString = ""
        }
        var output = ""
        for string in stringArray {
            output += string
        }
        output.writeToFile("/Users/madym/Documents/Workspace/Projects/LearnSwift/debug.txt", atomically: false, encoding: NSUTF8StringEncoding, error: nil);
    }
}