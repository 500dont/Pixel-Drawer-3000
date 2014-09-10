//
//  GridModel.swift
//  LearnSwift
//
//  Created by Mady Mellor on 9/4/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import Foundation

public class GridModel {
    
    var width: Int
    var height: Int
    
    var grid: [[NSColor?]]
    var drawActions: [DrawAction]
    var undoActions: [DrawAction]

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        grid = Array(count: width, repeatedValue: Array(count: height, repeatedValue: nil))
        drawActions = []
        undoActions = []
    }
    
    public func getColor(x: Int, y: Int) -> NSColor? {
        return grid[x][y]
    }
    
    public func addSquare(x: Int, y: Int, color: NSColor?, size: Int) -> Bool {
        // Bool to help identify if all squares match current squares, in this
        // situation we don't record the action (since it doesn't change state).
        var allMatch = true
        
        // Create the undo grid.
        var undoGrid = [NSColor?]()
        
        // Color the grid.
        let numX = min(x + size, width)
        let numY = min(y + size, height)
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                undoGrid.append(grid[i][j])
                if (grid[i][j] != color) {
                    allMatch = false
                }
                
                // TODO - figure out how to combine if let statements for optionals. (Try tuples?)
                if let prevColor = grid[i][j] {
                    if let c = color {
                        let newColor = c.blendedColorWithFraction(1-c.alphaComponent, ofColor: prevColor)
                        grid[i][j] = newColor
                    } else {
                        grid[i][j] = color
                    }
                } else {
                    grid[i][j] = color
                }

            }
        }
        
        // Create the draw action.
        if (!allMatch) {
            // Empty our undo stack - if the user has undone something and then drawn
            // something it makes most sense to clear it.
            undoActions = []
            
            let dr = DrawAction(origin: NSPoint(x: x, y: y), width: CGFloat(size), height: CGFloat(size), color: color, undo: undoGrid)
            drawActions.append(dr)
        }
        
        return !allMatch
    }
    
    public func clearGrid(withWidth: Int, withHeight: Int) {
        // Create the undo grid.
        var undoGrid = [NSColor?]()
        
        // Update the grid state.
        let numX = min(withWidth, width)
        let numY = min(withHeight, height)
        for (var i = 0; i < numX; i++) {
            for (var j = 0; j < numY; j++) {
                undoGrid.append(grid[i][j])
                grid[i][j] = nil
            }
        }
        let da = DrawAction(origin: NSPoint(x: 0,y: 0), width: CGFloat(numX), height: CGFloat(numY), color: nil, undo: undoGrid)
        drawActions.append(da)
    }
    
    public func applyUndo() {
        if (drawActions.isEmpty) {
            return
        }
        
        var da = drawActions.removeLast()
        var (point, undoGrid, undoWidth, undoHeight) = da.getUndoRect()
        let x = Int(point.x)
        let y = Int(point.y)
        
        // Set the color in necessary squares.
        let numX = min(width, x + Int(undoWidth))
        let numY = min(height, y + Int(undoHeight))
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                // Grid is reversed in getUndoRect() so removeLast is ok.
                let c = undoGrid.removeLast()
                grid[Int(i)][Int(j)] = c
            }
        }
        undoActions.append(da)
    }
    
    public func applyRedo() {
        if (undoActions.isEmpty) {
            return
        }
        
        var da = undoActions.removeLast()
        var (point, color, redoWidth, redoHeight) = da.getRedoRect()
        let x = Int(point.x)
        let y = Int(point.y)
        
        // Set the color in necessary squares.
        let numX = min(width, x + Int(redoWidth))
        let numY = min(height, y + Int(redoHeight))
        for (var i = x; i < numX; i++) {
            for (var j = y; j < numY; j++) {
                grid[Int(i)][Int(j)] = color
            }
        }
        drawActions.append(da)
    }
}
