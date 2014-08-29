//
//  DrawRecord.swift
//  LearnSwift
//

import Cocoa
import Foundation

public class DrawRecord {
    
    var firstPoint: NSPoint
    var size: Int
    
    init(firstPoint: NSPoint, size: Int) {
        self.firstPoint = firstPoint
        self.size = size
    }
    
    public func getSize() -> Int {
        return size
    }
    
    public func getFirstPoint() -> NSPoint {
        return firstPoint
    }
}