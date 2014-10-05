//
//  DrawAction.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class DrawAction {
    
    var origin: NSPoint
    var width: CGFloat
    var height: CGFloat
    var color: NSColor?
    
    var undoGrid: [NSColor?]
    
    init(origin:NSPoint, width: CGFloat, height: CGFloat, color: NSColor?, undo: [NSColor?]) {
        self.origin = origin
        self.width = width
        self.height = height
        self.color = color
        self.undoGrid = undo
    }
    
    public func getUndoRect() -> (NSPoint, [NSColor?], CGFloat, CGFloat) {
        return (origin, undoGrid.reverse(), width, height)
    }
    
    public func getRedoRect() -> (NSPoint, NSColor?, CGFloat, CGFloat) {
        return (origin, color, width, height)
    }
    
    public func getRect(squareSize: CGFloat) -> NSRect {
        return NSMakeRect(origin.x, origin.y, width*squareSize, height*squareSize)
    }
}