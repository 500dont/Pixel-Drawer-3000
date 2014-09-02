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
    
    var grid: [[NSColor?]]
    var drawActions: [DrawAction]
    var undoActions: [DrawAction]
    
    //
    // MARK: NSView
    //
    
    required public init(coder: NSCoder) {
        // TODO -- Not sure why this is needed? Swift / cocoa thing?
        fatalError("NSCoding not supported")
    }
    
    override init(frame: NSRect) {
        canvasColor = NSColor.whiteColor()
        selectedColor = NSColor.blueColor()
        brushSize = 1
        
        width = frame.width
        height = frame.height
        squareSize = 10
        
        grid = Array(count: Int(width / squareSize), repeatedValue: Array(count: Int(height / squareSize), repeatedValue: nil))
        drawActions = []
        undoActions = []
        
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
                if let color = grid[Int(i)][Int(j)] {
                    color.setFill()
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

    private func addSquare(atPoint: NSPoint, withColor: NSColor) {
        let point = convertToGridPoint(atPoint)
        let x = Int(point.x)
        let y = Int(point.y)

        // Only record actions if they are different.
        var allMatch = true
        
        // Create the undo grid.
        var undoGrid = [NSColor?]()
        
        // Update the grid state.
        let numX = min(x + Int(brushSize), Int(width/squareSize))
        let numY = min(y + Int(brushSize), Int(height/squareSize))
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                undoGrid.append(grid[i][j])
                if (grid[i][j] != withColor) {
                    allMatch = false
                }
                grid[i][j] = withColor
            }
        }
        
        // Create the draw action.
        if (!allMatch) {
            // Empty our undo stack - if the user has undid something and than drawn something
            // it makes most sense to clear it.
            undoActions = []
            
            let canvasPoint = NSPoint(x: point.x*squareSize, y: point.y*squareSize)
            let dr = DrawAction(origin: canvasPoint, width: brushSize, height: brushSize, color: withColor, undo: undoGrid)
            drawActions.append(dr)
            
            // Let the view know to draw.
            let r = NSMakeRect(CGFloat(x)*squareSize, CGFloat(y)*squareSize, brushSize*squareSize, brushSize*squareSize)
            setNeedsDisplayInRect(r)
        }
    }
    
    private func convertToGridPoint(point: NSPoint) -> NSPoint {
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
        addSquare(point, withColor: selectedColor)
    }
    
    override public func mouseDragged(theEvent: NSEvent!) {
        super.mouseDragged(theEvent)
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(point, withColor: selectedColor)
    }
    
    //
    // MARK: Undo / redo / clear
    //
    
    public func undo(goBackBy: NSInteger) {
        let actualGoBack = min(drawActions.count, goBackBy)
        for (var i = 0; i < actualGoBack; i++) {
            let da = drawActions.removeLast()
            applyUndo(da)
            undoActions.append(da)
        }
        needsDisplay = true
    }
    
    public func redo(goForward: NSInteger) {
        let actualGoForward = min(undoActions.count, goForward)
        for (var i = 0; i < actualGoForward; i++) {
            let da = undoActions.removeLast()
            applyRedo(da)
            drawActions.append(da)
        }
        
        needsDisplay = true
    }

    private func applyUndo(da: DrawAction) {
        var (point, undoGrid, width, height) = da.getUndoRect()
        
        let x = Int(point.x / squareSize)
        let y = Int(point.y / squareSize)
        
        // Set the color in necessary squares.
        let numX = x + Int(width)
        let numY = y + Int(height)
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                // Grid is reversed in getUndoRect() so removeLast is ok.
                let c = undoGrid.removeLast()
                grid[Int(i)][Int(j)] = c
            }
        }
    }
    
    private func applyRedo(da: DrawAction) {
        var (point, color, width, height) = da.getRedoRect()
        let x = Int(point.x / squareSize)
        let y = Int(point.y / squareSize)
        
        // Set the color in necessary squares.
        let numX = x + Int(width)
        let numY = y + Int(height)
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                grid[Int(i)][Int(j)] = color
            }
        }
    }
    
    public func clearScreen() {
        // Create the undo grid.
        var undoGrid = [NSColor?]()
        
        // Update the grid state.
        for (var i = 0; i < Int(width/squareSize); i++) {
            for (var j = 0; j < Int(height/squareSize); j++) {
                undoGrid.append(grid[i][j])
                grid[i][j] = nil
            }
        }
        let da = DrawAction(origin: NSPoint(x: 0,y: 0), width: width/squareSize, height: height/squareSize, color: nil, undo: undoGrid)
        drawActions.append(da)

        needsDisplay = true
    }
    
    //
    // MARK: Set user specified options
    //
    
    public func setColour(color: NSColor) {
        selectedColor = color
    }
    
    public func setCanvasColour(color: NSColor) {
        canvasColor = color
        needsDisplay = true
    }
    
    public func setBrushSize(size: CGFloat) {
        brushSize = size
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
                if let c = grid[i][j] {
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