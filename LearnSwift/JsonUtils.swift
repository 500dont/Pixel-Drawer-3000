//
//  JsonUtils.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class JsonUtils {
    
    public func doStuff(grid: GridModel, squareSize: Int, path: String!) {
        
        let (width, height) = grid.getSize()
        
        var gridA: [[MColor]]
        gridA = Array(count: width, repeatedValue: Array(count: height, repeatedValue: MColor(aColor: NSColor.whiteColor())))
        
        for (var i = 0; i < width; i++) {
            for (var j = 0; j < height; j++) {
                if let var color = grid.getColor(i, y: j) {
                    gridA[i][j] = MColor(aColor: color)
                }
            }
        }
        
        NSKeyedArchiver.archiveRootObject(gridA, toFile: path)
    }
    
    public func openStuff(url: NSURL!) -> GridModel! {
        let gridA = NSKeyedUnarchiver.unarchiveObjectWithFile(url.path) as NSArray
        return GridModel(mGrid: gridA)
    }
}