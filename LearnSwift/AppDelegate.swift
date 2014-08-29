//
//  AppDelegate.swift
//  LearnSwift
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var customView: Grid!

    @IBOutlet weak var colourWell: NSColorWell!
    @IBOutlet weak var canvasColourWell: NSColorWell!
    @IBOutlet weak var brushSizeView: NSTextField!
    @IBOutlet weak var undoRedoStepsView: NSTextField!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    //
    // Setting attributes.
    //
    
    @IBAction func onColourPicked(sender: NSColorWell) {
        customView.setColour(sender.color)
    }

    @IBAction func onCanvasColourPicked(sender: AnyObject) {
        customView.setCanvasColour(sender.color)
    }
    
    @IBAction func onBrushSizedChanged(sender: AnyObject) {
        var size = brushSizeView.integerValue
        customView.setBrushSize(CGFloat(size))
    }
    
    //
    // Undo / redo / clear.
    //
    
    @IBAction func onClearClicked(sender: AnyObject) {
        customView.clearScreen()
    }
    
    @IBAction func onUndo(sender: AnyObject) {
        customView.removeLastRect(undoRedoStepsView.integerValue)
    }
    
    @IBAction func onRedo(sender: AnyObject) {
        customView.readdRect(undoRedoStepsView.integerValue)
    }
    
    //
    // Save screen.
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
}

