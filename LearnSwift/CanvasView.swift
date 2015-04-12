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
    
    var replaceColorModeState: Bool
    var eraseState: Bool
    
    var drawCursor: Bool
    var cursorLoc: NSPoint
    
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
    
    override public var preservesContentDuringLiveResize: Bool {
        return true
    }

    override public func viewDidEndLiveResize() {
        // Update the grid size.
        var newWidth = frame.width / squareSize
        var newHeight = frame.height / squareSize
        grid.resize(Int(newWidth), newHeight: Int(newHeight))
        
        // Update canvas size.
        // TODO consider always using frame width / height rather than having my own?
        width = frame.width
        height = frame.height
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
        replaceColorModeState = false
        eraseState = false
        cursorLoc = NSPoint(x: 0, y: 0)
        drawCursor = false
        super.init(frame: frame)
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let x = Int(dirtyRect.origin.x / squareSize)
        let y = Int(dirtyRect.origin.y / squareSize)
        let aX = Int(dirtyRect.width / squareSize)
        let aY = Int(dirtyRect.height / squareSize)
        
        // Set the color in necessary squares.
        let numX = x + aX
        let numY = y + aY
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                var newColor = canvasColor
                if let color = grid.getColor(i, y: j) {
                    newColor = Utils().blendColor(color, colorAbove: canvasColor)
                }
                newColor.setFill()
                
                let r = NSMakeRect(CGFloat(i)*squareSize, CGFloat(j)*squareSize, squareSize, squareSize)
                NSRectFill(r)
            }
        }
        
        if (x == Int(cursorLoc.x) && y == Int(cursorLoc.y)) {
            selectedColor.setFill()
            let r = NSMakeRect(cursorLoc.x*squareSize, cursorLoc.y*squareSize, squareSize*brushSize, squareSize*brushSize)
            NSRectFill(r)
        }
    }
    
    //
    // MARK: Handling grid and draw state
    //

    private func addSquare(theEvent: NSEvent!, withColor: NSColor) {
        let point = convertToGridPoint(theEvent)
        let x = Int(point.x)
        let y = Int(point.y)
        var newColor: NSColor?
        newColor = withColor
        
        if (eraseState) {
            newColor = nil
        }

        let draw = grid.addSquare(x, y: y, color: newColor, size: Int(brushSize))
        
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
    
    override public func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(theEvent, withColor: selectedColor)
    }
    
    override public func mouseDragged(theEvent: NSEvent) {
        super.mouseDragged(theEvent)
        let point = convertPoint(theEvent.locationInWindow, fromView:nil)
        addSquare(theEvent, withColor: selectedColor)
    }
    
    override public func rightMouseDown(theEvent: NSEvent) {
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
    
    override public func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
        let prevCursor = cursorLoc
        cursorLoc = convertToGridPoint(theEvent)
        
        // Indicate to draw if necessary.
        // TODO - code used in multiple locations, helper method?
        let r = NSMakeRect(cursorLoc.x*squareSize, cursorLoc.y*squareSize, brushSize*squareSize, brushSize*squareSize)
        let pr = NSMakeRect(prevCursor.x*squareSize, prevCursor.y*squareSize, brushSize*squareSize, brushSize*squareSize)
        setNeedsDisplayInRect(r)
        setNeedsDisplayInRect(pr)


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
    // MARK: Misc buttons
    //
    
    public func toggleEraseState() -> Bool {
        eraseState = !eraseState;
        return eraseState;
    }
    
    public func getEraseState() -> Bool {
        return eraseState;
    }
    
    // Returns the new replace color state after the toggle.
    public func toggleReplaceColorState() -> Bool {
        replaceColorModeState = !replaceColorModeState;
        return replaceColorModeState;
    }
    
    public func replaceColor(selectedColor: NSColor, color: NSColor) {
        
    }
    
    //
    // MARK: Set user specified options
    //
    
    public func setColor(color: NSColor) {
        if (!replaceColorModeState) {
            selectedColor = color
        } else {
            replaceColor(selectedColor, color: color)

        }
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
    // MARK: Save / Open screen
    //
    
    public func saveScreen(url: NSURL!) {
        var beautifulArtwork = self.bitmapImageRepForCachingDisplayInRect(self.bounds)
        self.cacheDisplayInRect(self.bounds, toBitmapImageRep: beautifulArtwork!)
        var data = beautifulArtwork!.TIFFRepresentation
        var nsData = NSData(data: data!)
        nsData.writeToFile(url.path!, atomically: false)
        
        // Archive the file so that it can be opened.
        let dataPath = url.path! + ".pd3000"
        grid.archive(dataPath)
    }
    
    public func openFile(url: NSURL!) {
        let gridA = NSKeyedUnarchiver.unarchiveObjectWithFile(url.path!) as NSArray
        grid = GridModel(mGrid: gridA)
        needsDisplay = true
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