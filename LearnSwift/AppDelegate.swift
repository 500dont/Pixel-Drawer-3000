//
//  AppDelegate.swift
//  LearnSwift
//

import Cocoa

public class AppDelegate: NSObject, NSApplicationDelegate {
    
    let MAX_BRUSH_SIZE = 50
    
    var DEBUG = false
    
    var colorPanel: NSColorPanel?
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var customView: CanvasView!

    @IBOutlet weak var colorPalette: NSColorWell!
    @IBOutlet weak var canvasColourWell: NSColorWell!
    @IBOutlet weak var brushSizeView: NSTextField!
    @IBOutlet weak var gridSizeView: NSTextField!
    @IBOutlet weak var undoRedoStepsView: NSTextField!

    public func applicationDidFinishLaunching(aNotification: NSNotification?) {
        customView.setAppDelegate(self)
        // TODO - uncomment when alpha working.
         colorPanel = NSColorPanel.sharedColorPanel()
         colorPanel!.showsAlpha = true
    }

    public func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func onDebug(sender: AnyObject) {
        customView.printGrid()
    }
    
    //
    // MARK: Handling UI changes
    //
    
    public func setPaletteColor(color: NSColor) {
        colorPalette.color = color
    }
    
    //
    // MARK: Setting attributes
    //
    
    @IBAction func onColourPicked(sender: NSColorWell) {
        customView.setColor(sender.color)
    }

    @IBAction func onCanvasColourPicked(sender: AnyObject) {
        customView.setCanvasColour(sender.color)
    }
    
    @IBAction func onBrushSizedChanged(sender: AnyObject) {
        let size = min(brushSizeView.integerValue, MAX_BRUSH_SIZE)
        customView.setBrushSize(CGFloat(size))
    }
    
    @IBAction func onGridSizeChanged(sender: AnyObject) {
        let size = gridSizeView.integerValue
        customView.setGridSize(CGFloat(size))
    }
    
    //
    // MARK: Clear / undo / redo
    //
    
    @IBAction func onClearClicked(sender: AnyObject) {
        customView.clearScreen()
    }
    
    @IBAction func onUndo(sender: AnyObject) {
        customView.undo(undoRedoStepsView.integerValue)
    }
    
    @IBAction func onRedo(sender: AnyObject) {
        customView.redo(undoRedoStepsView.integerValue)
    }
    
    //
    // MARK: Hot keys
    //
    
    @IBAction func onIncreaseBrushSize(sender: AnyObject) {
        let size = min(brushSizeView.integerValue + 1, MAX_BRUSH_SIZE)
        brushSizeView.integerValue = size
        customView.setBrushSize(CGFloat(size))
    }
    
    @IBAction func onDecreaseBrushSize(sender: AnyObject) {
        let size = max(brushSizeView.integerValue - 1, 1)
        brushSizeView.integerValue = size
        customView.setBrushSize(CGFloat(size))
    }
    
    //
    // MARK: Save screen
    //
    
    @IBAction func onSave(sender: AnyObject) {
        save()
    }
    
    @IBAction func onSaveAs(sender: AnyObject) {
        save()
    }
    
    private func save() {
        var savePanel = NSSavePanel()
        savePanel.beginWithCompletionHandler { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                var exportedFileURL = savePanel.URL
                self.customView.saveScreen(exportedFileURL)
            }
        }
    }
    
    private func saveProgress() {
        
    }
}

