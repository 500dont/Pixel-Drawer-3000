//
//  ColorState
//  LearnSwift
//

import Cocoa
import Foundation

public class ColorState {
    
    var colorIndex: Int
    var colorList: [NSColor]
    
    init() {
        colorIndex = -1
        colorList = []
    }
    
    init(color: NSColor) {
        colorList = []
        colorList.append(color)
        colorIndex = 0
    }
    
    public func addColor(color: NSColor!) {
        colorList.append(color)
        colorIndex += 1
    }
    
    public func getColor() -> NSColor? {
        if (colorIndex >= 0 && colorList.count > colorIndex) {
            return colorList[colorIndex]
        }
        return nil
    }
    
    public func goBack() {
        colorIndex = max(colorIndex - 1, 0)
    }
    
    public func goForward() {
        colorIndex = min(colorIndex + 1, colorList.count - 1)
    }
}