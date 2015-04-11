//
//  GridModel.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class GridModel {
    
    var width: Int
    var height: Int
    
    var grid: [[NSColor?]]
    var drawActions: [DrawAction]
    var undoActions: [DrawAction]
    var colorDict: ColorDictionary

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        grid = Array(count: width, repeatedValue: Array(count: height, repeatedValue: nil))
        drawActions = []
        undoActions = []
        colorDict = ColorDictionary()
    }
    
    public init(mGrid: NSArray) {
        var mColorGrid:[[MColor]]
        mColorGrid = mGrid as [[MColor]];
        
        self.width = mColorGrid.count
        self.height = mColorGrid[0].count
        
        grid = Array(count: width, repeatedValue: Array(count: height, repeatedValue: nil))
        for (var i = 0; i < width; i++) {
            for (var j = 0; j < height; j++) {
                var color = mColorGrid[i][j]
                if color.isBackground {
                    grid[i][j] = nil
                } else {
                    var ncolor = NSColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
                    grid[i][j] = ncolor
                }
            }
        }
        drawActions = []
        undoActions = []
        colorDict = ColorDictionary()
    }
    
    public func getColor(x: Int, y: Int) -> NSColor? {
        // This check is included as during re-size the dirtyRect will be larger than the
        // current grid size. Ideally the grid will be updated in size to reflect this before
        // getting to this point, however, that is not the case currently.
        if (x < width && y < height) {
            return grid[x][y]
        } else {
            return nil
        }
    }

    public func getSize() -> (Int, Int) {
        return (width, height)
    }
    
    public func getGrid() -> [[NSColor?]] {
        return grid
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
                        let newColor = Utils().blendColor(c, colorAbove: prevColor)
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
            
            // Record this color & location in hashmap.
            if (color != nil) {
                colorDict.store(key: color!, action: dr)
            }
        }
        
        return !allMatch
    }
    
    class ColorDictionary {
        var dictionary = Dictionary<NSColor, Array<DrawAction>>()
        
        func store(#key: NSColor, action: DrawAction) {
            if (dictionary[key] != nil) {
                var tlist = dictionary[key]!
                tlist.append(action)
                set(key: key, list: tlist)
            } else {
                var list = Array<DrawAction>()
                list.append(action)
                dictionary[key] = list
            }
        }
        
        func set(#key: NSColor, list: Array<DrawAction>) {
            dictionary[key] = list
        }
        
        func get(#key: NSColor) -> Array<DrawAction>? {
            return dictionary[key]
        }
        
        func has(#key: NSColor) -> Bool {
            if (dictionary[key] != nil) {
                return true
            } else {
                return false
            }
        }
    }
    
    public func replaceColor(replace: NSColor, withColor: NSColor) {
        
        // 1. See if color to replace is used
        
        
        // 2. If it is, replace all locations
        
        // 3. If it isn't, do nothing.
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
    
    public func resize(newWidth: Int, newHeight: Int) {
        // Lets do this the most straight forward / bad way for now too.
        var newGrid: [[NSColor?]] = Array(count: newWidth, repeatedValue: Array(count: newHeight, repeatedValue: nil))
        
        let numX = min(width, newWidth)
        let numY = min(height, newHeight)
        // Copy the values.
        for (var i = 0; i < numX; i++) {
            for (var j = 0; j < numY; j++) {
                newGrid[i][j] = grid[i][j]
            }
        }
        
        // Set the new grid.
        grid = newGrid
        
        // Update the size.
        width = newWidth
        height = newHeight
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
    
    public func archive(path: String!) {
        var arcGrid = Array(count: width, repeatedValue: Array(count: height, repeatedValue: MColor(aColor: nil)))
        
        for (var i = 0; i < width; i++) {
            for (var j = 0; j < height; j++) {
                if let var color = grid[i][j] {
                    arcGrid[i][j] = MColor(aColor: color)
                }
            }
        }
        
        NSKeyedArchiver.archiveRootObject(arcGrid, toFile: path)
    }
}
