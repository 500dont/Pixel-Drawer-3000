//
//  AppDelegate.swift
//  LearnSwift
//

import Cocoa

public class AppDelegate: NSResponder, NSApplicationDelegate {
    
    let MAX_BRUSH_SIZE = 50
    
    var DEBUG = false
    
    var colorPanel: NSColorPanel?
    var ColorPanelColorContext = UnsafeMutablePointer<()>()
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var customView: CanvasView!

    @IBOutlet weak var colorPalette: NSColorWell!
    @IBOutlet weak var canvasColourWell: NSColorWell!
    @IBOutlet weak var brushSizeView: NSTextField!
    @IBOutlet weak var gridSizeView: NSTextField!
    @IBOutlet weak var undoRedoStepsView: NSTextField!
    @IBOutlet weak var eraseColorButton: NSButton!
    @IBOutlet weak var replaceColorButton: NSButton!

    public func applicationDidFinishLaunching(aNotification: NSNotification?) {
        customView.setAppDelegate(self)
        colorPanel = NSColorPanel.sharedColorPanel()
        colorPanel!.showsAlpha = true
        window.makeFirstResponder(self)
//        undoRedoStepsView.addTarget(self, action: Selector("onIncreaseUndoSteps:"), forControlEvents: UIControlEvents.ValueChanged)
//        undoRedoStepsView.addTarget(self, action: Selector("onDecreaseUndoSteps:"), forControlEvents: UIControlEvents.ValueChanged)

    }

    public func applicationWillTerminate(aNotification: NSNotification?) {
        // TODO - Possibly this is where I could save window locations?
    }
    
    @IBAction func onDebug(sender: AnyObject) {
        customView.printGrid()
    }
    
    override public func keyDown(theEvent: NSEvent) {
        let chars = theEvent.characters
        //println("keydown: " + !chars);
    }

    //
    // MARK: Handling UI changes
    //
    
    public func setPaletteColor(color: NSColor) {
        colorPalette.color = color
        if (customView.getEraseState()) {
            onEraseButtonClicked(self)
        }
    }
    
    //
    // MARK: Setting attributes
    //
    
    @IBAction func onColourPicked(sender: AnyObject) {
        if (customView.getEraseState()) {
            onEraseButtonClicked(sender)
        }
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
    // MARK: Misc buttons
    //
    
    
    @IBAction func onEraseButtonClicked(sender: AnyObject) {
        let state = customView.toggleEraseState()
        eraseColorButton.title = !state ? "Erase" : "Stop erasing"
    }
    
    @IBAction func onReplaceColorButtonClicked(sender: AnyObject) {
        let state = customView.toggleReplaceColorState();
        replaceColorButton.title = !state ? "Replace color" : "Save selected"
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

    @IBAction func onIncreaseUndoSteps(sender: AnyObject) {
        let steps = undoRedoStepsView.integerValue + 1
        undoRedoStepsView.stringValue = String(format: steps.description)
    }

    @IBAction func onDecreaseUndoSteps(sender: AnyObject) {
        let steps = undoRedoStepsView.integerValue
        let newValue = max(1, steps-1)
        undoRedoStepsView.stringValue = String(format: newValue.description)
    }
    
    //
    // MARK: Frame tool window
    //
    
    @IBAction func onNewFrame(sender: AnyObject) {
        print("on new frame")
    }
    
    @IBAction func onGhostPrev(sender: AnyObject) {
        print("on ghost prev")
    
    }
    
    @IBAction func onGhostNext(sender: AnyObject) {
        print("on ghost next")
    }
    
    //
    // MARK: Save screen
    //
    @IBAction func onOpen(sender: AnyObject) {
        var openPanel = NSOpenPanel()
        openPanel.beginWithCompletionHandler { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
            var exportedFileURL = openPanel.URL
            self.customView.openFile(exportedFileURL)
            }
        }
    }
    
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

