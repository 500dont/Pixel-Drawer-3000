//
//  AppDelegate.swift
//  LearnSwift
//
//  Created by Mady Mellor on 8/10/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var colourWell: NSColorWell!
    @IBOutlet weak var canvasColourWell: NSColorWell!
    @IBOutlet weak var customView: Canvas!
    @IBOutlet weak var brushSizeView: NSTextField!
    @IBOutlet weak var undoRedoStepsView: NSTextField!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    @IBAction func onColourPicked(sender: NSColorWell) {
        customView.setColour(sender.color)
    }

    @IBAction func onCanvasColourPicked(sender: AnyObject) {
        customView.setCanvasColour(sender.color)
    }
    
    @IBAction func onClearClicked(sender: AnyObject) {
        customView.clearScreen()
    }
    
    @IBAction func onBrushSizedChanged(sender: AnyObject) {
        var size = brushSizeView.integerValue
        println("brush size changed: " + size.description)
        customView.setBrushSize(CGFloat(size))
    }
    
    @IBAction func onUndo(sender: AnyObject) {
        customView.removeLastRect(undoRedoStepsView.integerValue)
    }
    
    @IBAction func onRedo(sender: AnyObject) {
        customView.readdRect(undoRedoStepsView.integerValue)
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
}

