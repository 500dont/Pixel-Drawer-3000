Pixel-Drawer-3000
=================

Learn Swift Project: Pixel art drawing app.

See creations from PD3000 here: [https://github.com/toastitos/Pixel-Drawer-3000/tree/master/Examples](https://github.com/toastitos/Pixel-Drawer-3000/tree/master/Examples)

### Current features
- Change brush size, brush colour
- Change canvas colour
- Undo / redo 
- Clear screen
- Save (note .tiff / .png should be added to file name; other formats may work but they are untested)

### Detailed functionality description
- Changing the brush size will still adhere to the squareSize of the grid. This is currently hardcoded at 10 and will eventually be customizable.
- Changing the canvas colour is not considered an "action" that is, you can not undo / redo it. 
- Undo / redo is handled slightly differently from the norm - that is each brush impression is considered an undoable action. In most drawing applications an action is considered: click > drag over 10 squares > unclick, undoing this would undo the whole action. In PD3000 hitting undo would undo each square individually. Note that you can set the number of squares to undo / redo in the UI. The rationale behind this choice is that often when drawing pixel type drawings you'll click and hold, and mess up the last x pixels. Hitting undo undos all of the good work plus the x pixels you messed up. This undo / redo approach is more granular allowing the artist greater control.

### Download
Try out v0.1 here:
[https://github.com/toastitos/Pixel-Drawer-3000/blob/master/PixelDrawer3000-v0.1.zip](https://github.com/toastitos/Pixel-Drawer-3000/blob/master/PixelDrawer3000-v0.1.zip)

### Features in progress
- Loading functionality - want to allow the ability to save a file and load a file
- Changing the size of the squares on the grid
- Changing the size of the canvas, scrolling within window
- Hot keys for changing brush size
