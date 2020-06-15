# dwg2d
Cross platform vector graphic components

You can install this package in the Lazarus IDE. Then you get the new component class TDrawing2D in the component palette in the group Misc. If the package source code version will be newer than this file, there might be additional components in future. View the application project https://github.com/jakobsche/mofu as an example, how the package can be used! Alternatively, put this component on a form, point to a control or canvas and call the Draw method of the graphic in a OnPaint Event or something that is OK to draw the TDrawing2D component on a canvas when it has to be updated. Then you can try the methods of the component. This prototype of TDrawing2D draws TElement components, that it owns.
