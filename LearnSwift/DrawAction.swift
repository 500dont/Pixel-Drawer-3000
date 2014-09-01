//
//  DrawAction
//  LearnSwift
//

import Cocoa
import Foundation

public class DrawAction {
    
    var origin: NSPoint
    var size: CGFloat
    var color: NSColor
    
    var undoGrid: [NSColor?]
    
    init(origin: NSPoint, size: CGFloat, color: NSColor, undo: [NSColor?]) {
        self.origin = origin
        self.size = size
        self.color = color
        self.undoGrid = undo
    }
    
    public func getUndoRect() -> (NSPoint, [NSColor?], CGFloat) {
        return (origin, undoGrid.reverse(), size)
    }
    
    public func getRedoRect() -> (NSPoint, NSColor, CGFloat) {
        return (origin, color, size)
    }
    
    public func getRect(squareSize: CGFloat) -> NSRect {
        return NSMakeRect(origin.x, origin.y, size*squareSize, size*squareSize)
    }
}