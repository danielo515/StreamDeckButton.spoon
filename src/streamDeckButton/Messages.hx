package streamDeckButton;

import lua.Table.create as t;
import hammerspoon.Image;
import hammerspoon.Alert;

class Utils {
  public static function loadImageAsBase64(imagePath:String):Null< String > {
    var image = Image.imageFromPath(imagePath);
    if (image != null) {
      var imageData = image.encodeAsURLString();
      return imageData;
    }
    return null;
  }
}

function getTitleMessage(context:String, title:String) {
  return t({
    event: "setTitle",
    context: context,
    payload: t({
      title: title,
      target: 0
    })
  });
}

function showOkMessage(context) {
  return t({
    event: "showOk",
    context: context
  });
}

/**
  StreamDeckButton.getImageMessage(context, imagePath)
  Function
  Generates an image message for the StreamDeckButton

  Parameters:
  * context - A string containing the context for the button
  * imagePath - A string containing the path to the image file

  Returns:
  * An event table if the image was successfully loaded, otherwise null
**/
function getImageMessage(context:String, imagePath:String):Null< Dynamic > {
  var imageBase64 = Utils.loadImageAsBase64(imagePath);
  if (imageBase64 != null) {
    return t({
      event: "setImage",
      context: context,
      payload: t({
        image: imageBase64,
        target: 0,
        state: 0
      })
    });
  } else {
    Alert.show("Image not loaded: " + imagePath);
    return null;
  }
}
