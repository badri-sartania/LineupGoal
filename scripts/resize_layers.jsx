/*

    This script resizes every layer within the active document.

    How to use:
    - Photoshop script ( cs3+ )
    - Put in {photoshop_root}/presets/scripts/Resize Each Layer.jsx
        - Run from: File > Scripts > Resize Each Layer
        - ..or save the file where ever you want and run from there with: File > Scripts > Browse...

*/

/*

    <javascriptresource>
    <name>$$$/JavaScripts/resizeeachlayer/Menu=Resize Each Layer</name>
    <category>Resizing</category>
    <enableinfo>true</enableinfo>
    <eventid>64feff0a-8271-436f-8c59-d2105497d903</eventid>
    </javascriptresource>

*/

function resizeToBounds(layer, width, height, constrain){
    /**
     * Active layer bounds.
     * @param {UnitValue} layerBounds
     */
    var layerBounds;

    /**
     * Active layer width.
     * @type {Number}
     */
    var layerWidth;

    /**
     * Active layer height.
     * @type {Number}
     */
    var layerHeight;

  /**
   * Width resizing scale (if given).
   * @type {Number}
   */
    var scaleWidth;

    /**
     * Height resizing scale (if given).
     * @type {Number}
     */
    var scaleHeight;

    /**
     * Mutual scale used if proportions should be constrained.
     * @type {Number}
     */
    var scale;

    /**
     * New layer width expressed in percentages compared to the initial width (Photoshop loooooves percentages :'()
     * @type {Number}
     */
    var newWidth;

    /**
     * New layer height expressed in percentages compared to the initial height (did I mention that Photoshop loooooves percentages?)
     * @type {Number}
     */
    var newHeight;

  layerBounds = layer.bounds;
  layerWidth = layerBounds[2].value - layerBounds[0].value;
  layerHeight = layerBounds[3].value - layerBounds[1].value;

  // Resizing scales... At least those which we can calculate...
  if(width){
    scaleWidth = width / layerWidth;
  }
  if(height){
    scaleHeight = height / layerHeight;
  }

  if(constrain){
    // Aspect ratio should be kept during resize (using a mutual scale) and still fit into the target bounding box.
    if(!width || !height){
      // At least one of the target dimensions is missing, using the available one for scale.
      if(!width){
        scale = scaleHeight;
      } else {
        scale = scaleWidth;
      }
    } else {
      // Both dimensions are available.
      if(scaleWidth >= scaleHeight){
        scale = scaleHeight;
      } else {
        scale = scaleWidth;
      }
    }
    newWidth = scale * 100;
    newHeight = scale * 100;
  } else {
    // No aspect ratio constrains set - resizing by width and height (both values are percentages!).
    newWidth = scaleWidth * 100;
    newHeight = scaleHeight * 100;
  }

  // Performing the resize.
  layer.resize(newWidth, newHeight, AnchorPosition.MIDDLECENTER);
}

try {

  // Currently active document.
  var doc = app.activeDocument;

  // All layers
  var layers = doc.artLayers;

  // Run dialog...
  //var width = 69;
  //var height = 48;

  var width = 34;
  var height = 24;

  // Loop through every layer...
  for( var i = 0 ; i < doc.artLayers.length; i++ ){

    var activeLayer = doc.artLayers.getByName( doc.artLayers[ i ].name  );

    // Save original ruler units
    var orUnits = app.preferences.rulerUnits;

    // Change rulerunits to percent
    app.preferences.rulerUnits = Units.PIXELS;



    // RESSIIIIIIIZE
    resizeToBounds(activeLayer, width, height, true)

    //activeLayer.resize( 69, 48, AnchorPosition.MIDDLECENTER );

    // Roll back to original ruler units
    app.preferences.rulerUnits = orUnits;

  }


} // try end

catch( e ) {
  // remove comments below to see error for debugging
  // alert( e );
}


function dialog() {

  // Dialog box...
  var myWindow = new Window ("dialog", "Resize Each Layer");

  // Keeps things inline
  myWindow.orientation = "row";

  // Informational text
  myWindow.add ("statictext", undefined, "New size ( percentage ):");

  // This is the box where the size is inserted
  var myText = myWindow.add ("edittext", undefined, "");
  myText.characters = 5;
  myText.active = true;

  // Ok....
  myWindow.add ("button", undefined, "OK");
  if (myWindow.show () == 1) return myText.text;

}
