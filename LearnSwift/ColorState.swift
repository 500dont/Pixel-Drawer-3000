//
//  ColorState
//  LearnSwift
//

import Cocoa
import Foundation

public class ColorState {
    
    var colorList: [NSColor]
    
    init() {
        colorList = []
    }
    
    init(color: NSColor) {
        colorList = []
        colorList.append(color)
    }
    
    public func addColor(color: NSColor!) {
        colorList.append(color)
    }
    
    public func removeColor() {
        if (!colorList.isEmpty) {
            colorList.removeLast()
        }
    }
    
    public func getColor() -> NSColor? {
        if (!colorList.isEmpty) {
            return colorList.last
        }
        return nil
    }
}