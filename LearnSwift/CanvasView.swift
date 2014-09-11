//
//  CanvasView.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class CanvasView: NSView {
    
    var appDelegate: AppDelegate?
    
    var canvasColor: NSColor
    var selectedColor: NSColor
    var brushSize: CGFloat
    
    var width: CGFloat
    var height: CGFloat
    var squareSize: CGFloat
    
    var grid: GridModel
    
    //
    // MARK: NSView
    //
    
    public required init(coder: NSCoder) {
        // TODO -- Not sure why this is needed? Swift / cocoa thing?
        fatalError("NSCoding not supported")
    }
    
    public func setAppDelegate(appDel: AppDelegate) {
        appDelegate = appDel
    }
    
    override init(frame: NSRect) {
        appDelegate = nil // Set later.
        
        canvasColor = NSColor(calibratedRed: 255.0, green: 255.0, blue: 255.0, alpha: 1)
        selectedColor = NSColor(calibratedRed: 0, green: 0, blue: 255.0, alpha: 1)
        brushSize = 1
        
        width = frame.width
        height = frame.height
        squareSize = 10
        
        grid = GridModel(width: Int(width/squareSize), height: Int(height/squareSize))
        
        super.init(frame: frame)
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let aX = Int(dirtyRect.width / squareSize)
        let aY = Int(dirtyRect.height / squareSize)
        let x = Int(dirtyRect.origin.x / squareSize)
        let y = Int(dirtyRect.origin.y / squareSize)
        
        // Set the color in necessary squares.
        let numX = x + aX
        let numY = y + aY
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                if let color = grid.getColor(i, y: j) {
                    // color.setFill()
                    let blendedColor = color.blendedColorWithFraction(color.alphaComponent, ofColor: canvasColor)
                    let newColor = Utils().blendColor(color, colorAbove: canvasColor)
                    newColor.setFill()
                } else {
                    canvasColor.setFill()
                }
                let r = NSMakeRect(CGFloat(i)*squareSize, CGFloat(j)*squareSize, squareSize, squareSize)
                NSRectFill(r)
            }
        }
    }
    
    //
    // MARK: Handling grid and draw state
    //

    private func addSquare(theEvent: NSEvent!, withColor: NSColor) {
        let point = convertToGridPoint(theEvent)
        let x = Int(point.x)
        let y = Int(point.y)

        let draw = grid.addSquare(x, y: y, color: withColor, size: Int(brushSize))
        
        if (draw) {
            // Indicate to draw if necessary.
            let r = NSMakeRect(CGFloat(x)*squareSize, CGFloat(y)*squareSize, brushSize*squareSize, brushSize*squareSize)
            setNeedsDisplayInRect(r)
        }
    }
    
    private func convertToGridPoint(theEvent: NSEvent!) -> NSPoint {
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        let x = point.x
        let y = point.y
        
        // Get the points locked to grid size.
        let lx = max(x - (x % squareSize), 0)
        let ly = max(y - (y % squareSize), 0)
        return NSPoint(x: lx / squareSize, y: ly / squareSize)
    }
    
    //
    // MARK: Handling drawing input
    //
    
    override public func mouseDown(theEvent: NSEvent!) {
        super.mouseDown(theEvent)
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(theEvent, withColor: selectedColor)
    }
    
    override public func mouseDragged(theEvent: NSEvent!) {
        super.mouseDragged(theEvent)
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(theEvent, withColor: selectedColor)
    }
    
    override public func rightMouseDown(theEvent: NSEvent!) {
        super.rightMouseDown(theEvent)
        let point = convertToGridPoint(theEvent)
        let x = Int(point.x)
        let y = Int(point.y)
        
        if let color = grid.getColor(x, y: y) {
            self.setColor(color)
            // Safe to unpack appDelegate here - can't click the view if it hasn't been set.
            appDelegate!.setPaletteColor(color)
        }
    }
    
    //
    // MARK: Undo / redo / clear
    //
    
    public func undo(goBackBy: NSInteger) {
        for (var i = 0; i < goBackBy; i++) {
            grid.applyUndo()
        }
        needsDisplay = true
    }
    
    public func redo(goForward: NSInteger) {
        for (var i = 0; i < goForward; i++) {
            grid.applyRedo()
        }
        needsDisplay = true
    }

    public func clearScreen() {
        grid.clearGrid(Int(width/squareSize), withHeight: Int(height/squareSize))
        needsDisplay = true
    }
    
    //
    // MARK: Set user specified options
    //
    
    public func setColor(color: NSColor) {
        selectedColor = color
    }
    
    public func setCanvasColour(color: NSColor) {
        canvasColor = color
        needsDisplay = true
    }
    
    public func setBrushSize(size: CGFloat) {
        brushSize = size
    }
    
    public func setGridSize(size: CGFloat) {
        squareSize = size
        needsDisplay = true
    }
    
    //
    // MARK: Save screen
    //
    
    public func saveScreen(url: NSURL!) {
        var beautifulArtwork = self.bitmapImageRepForCachingDisplayInRect(self.bounds)
        self.cacheDisplayInRect(self.bounds, toBitmapImageRep: beautifulArtwork!)
        var data = beautifulArtwork!.TIFFRepresentation
        var nsData = NSData.self.dataWithData(data)
        nsData.writeToFile(url.path, atomically: false)
    }

    //
    // MARK: Best debug function ever
    //
    public func printGrid() {
        var colorInt = 0
        var prevColors = [NSColor: Int]()
        var stringArray = [String]()
        for (var i = 0; i < Int(width/squareSize); i++) {
            var rowString = "row " + i.description + ": "
            for (var j = 0; j < Int(height/squareSize); j++) {
                if let c = grid.getColor(i, y: j) {
                    if let thisColor = prevColors[c] {
                        rowString += "[" + thisColor.description + "]"
                    } else {
                        colorInt += 1
                        prevColors[c] = colorInt
                        rowString += "[" + colorInt.description + "]"
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