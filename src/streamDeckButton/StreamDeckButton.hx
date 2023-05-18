package streamDeckButton;

import hammerspoon.Hammerspoon.HttpServer;
import hammerspoon.Json;
import hammerspoon.Logger;
import haxe.DynamicAccess;

@:expose("StreamDeckButton") @:native("obj")
class StreamDeckButton {
  public final name:String = "StreamDeckButton";
  public final version:String = "3.0.0";
  public final author:String = "Danielo Rodríguez <rdanielo@gmail.com>";
  public final license:String = "MIT - https://opensource.org/licenses/MIT";
  public final homepage:String = "https://github.com/danielo515/StreamDeckButton.spoon";
  public final logger = Logger.make("StreamDeckButton", "debug");
  public var contexts:Null< State > = null;
  public var server:Null< HttpServer >;

  public var keyDownSubscribers:DynamicAccess< Array< Dynamic > > = new DynamicAccess< Array< Dynamic > >();
  public var willAppearSubscribers:DynamicAccess< Array< Dynamic > > = new DynamicAccess< Array< Dynamic > >();

  static public function init():Void {}

  public function onKeyDown(id:String, callback:Dynamic -> Dynamic -> Void):Void {
    if (id == null || callback == null) {
      return;
    }
    if (keyDownSubscribers[id] == null) {
      keyDownSubscribers[id] = [];
    }
    keyDownSubscribers[id].push(callback);
  }

  public function onWillAppear(id:String, callback:Dynamic -> Dynamic -> Void):Void {
    if (id == null || callback == null) {
      return;
    }
    if (willAppearSubscribers[id] == null) {
      willAppearSubscribers[id] = [];
    }
    willAppearSubscribers[id].push(callback);
  }

  public function msgHandler(message:String):String {
    logger.d("Received message");
    var params = Messages.parseMessage(message);
    trace(params);
    switch (params) {
      case Left(error):
        logger.e("Error parsing message: %s", error);
        return "";
      case Right({payload: {settings: s}, context: ctx, event: event}):
        if (contexts == null) {
          logger.e("Contexts is null");
          return "";
        }
        contexts.run(contexts -> {
          if (!contexts.exists(s.id)) {
            setTitle(ctx, "Initializing");
            logger.f("new id found: %s with this context: %s", s.id, ctx);
          }
          contexts.addContext(s.id, ctx);
        });

        final response = switch (event) {
          case "keyDown":
            if (keyDownSubscribers.exists(ctx)) {
              for (callback in keyDownSubscribers[ctx]) {
                callback(ctx, params);
              }
            }
            Messages.showOkMessage(ctx);
          case "willAppear":
            if (willAppearSubscribers.exists(ctx)) {
              for (callback in willAppearSubscribers[ctx]) {
                callback(ctx, params);
              }
            }
            Messages.showOkMessage(ctx);
          default:
            Messages.showOkMessage(ctx);
        };
        return Json.encode(response);
    }
    return "";
  }

  public function setTitle(context:String, title:String) {
    server!.send(Json.encode(Messages.getTitleMessage(context, title)));
  }

  /**
    StreamDeckButton.setImage(id, imagePath)
    Method
    Sets the image for a specific button

    Parameters:
    * id - The identifier for the button
    * imagePath - The path to the image to set
  **/
  public function setImage(id:String, imagePath:String) {
    if (id == null || !contexts!.exists(id).or(false)) {
      logger.ef("setImage: id is null or contexts[id] is null", id);
      return;
    }
    contexts.run(ctx -> {
      final ctxs = ctx.get(id);
      if (ctxs == null) {
        logger.ef("setImage for %s leads to no context", id);
        return;
      }
      for (context in ctxs) {
        var message = Messages.getImageMessage(context, imagePath);
        if (message == null) {
          logger.ef("Error generating image message for %s", imagePath);
          return;
        }
        server!.send(Json.encode(message));
      }
    });
  }

  public function start(port:Int) {
    contexts = State.getInstance();
    server = HttpServer.make(false, true);
    server.apply(server -> {
      server.setPort(port);
      server.setName(name);
      server.setCallback(() -> "");
      server.websocket('/ws', msgHandler);
      server.start();
      logger.f("Server started %s", server);
    });
  }

  // TODO: Implement the following methods using the Haxe modules mentioned above:
  // - stop
}
