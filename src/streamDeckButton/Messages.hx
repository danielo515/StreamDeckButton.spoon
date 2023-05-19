package streamDeckButton;

import haxe.ds.Either;
import lua.Table.create as t;
import hammerspoon.Image;
import hammerspoon.Alert;

enum abstract Event(String) {
  final KeyDown = "keyDown";
  final WillAppear = "willAppear";
  final WillDisappear = "willDisappear";
  final KeyUp = "keyUp";
}

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

abstract MessageID(String) {}

/**
  {
  action = "org.tynsoe.streamdeck.wsproxy.proxy",
  context = "7b7c8d2f0058edcea54c0e75775864a9",
  device = "052B523D48DA807DD12736B4A4226765",
  event = "keyDown",
  payload = {
    coordinates = {
      column = 0,
      row = 0
    },
    isInMultiAction = false,
    settings = {
      id = "routine",
      remoteServer = "ws://localhost:3094/ws"
    }
  }
  }
**/
typedef IncomingMessage = {
  final event:String;
  final context:String;
  final payload:{
    final coordinates:{
      final column:Int;
      final row:Int;
    };
    final isInMultiAction:Bool;
    final settings:{
      final id:MessageID;
      final remoteServer:String;
    };
  };
};

function parseMessage(message:String):Either< String, IncomingMessage > {
  final parsed = hammerspoon.Json.decode(message);
  if (parsed == null) {
    return Left("Invalid JSON: " + message);
  }
  if (parsed.event == null) {
    return Left("Missing event: " + message);
  }
  if (parsed.context == null) {
    return Left("Missing context: " + message);
  }
  if (parsed.payload == null) {
    return Left("Missing payload: " + message);
  }
  if (parsed.payload.coordinates == null) {
    return Left("Missing coordinates: " + message);
  }
  if (parsed.payload.coordinates.column == null) {
    return Left("Missing column: " + message);
  }
  if (parsed.payload.coordinates.row == null) {
    return Left("Missing row: " + message);
  }
  if (parsed.payload.isInMultiAction == null) {
    return Left("Missing isInMultiAction: " + message);
  }
  if (parsed.payload.settings == null) {
    return Left("Missing settings: " + message);
  }
  if (parsed.payload.settings.id == null) {
    return Left("Missing id: " + message);
  }
  if (parsed.payload.settings.remoteServer == null) {
    return Left("Missing remoteServer: " + message);
  }
  final value:IncomingMessage = {
    event: parsed.event,
    context: parsed.context,
    payload: {
      coordinates: {
        column: parsed.payload.coordinates.column,
        row: parsed.payload.coordinates.row
      },
      isInMultiAction: parsed.payload.isInMultiAction,
      settings: {
        id: parsed.payload.settings.id,
        remoteServer: parsed.payload.settings.remoteServer
      }
    }
  };
  return Right(value);
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
