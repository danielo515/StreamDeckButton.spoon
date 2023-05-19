package streamDeckButton;

import streamDeckButton.Messages.IncomingMessage;
import streamDeckButton.Messages.MessageID;
import hammerspoon.Hammerspoon.HttpServer;
import hammerspoon.Json;
import hammerspoon.Logger;
import haxe.DynamicAccess;

typedef Subscriber = String -> IncomingMessage -> Null< Dynamic >;

@:expose("StreamDeckButton") @:native("obj")
class StreamDeckButton {
  // Metadata
  public final name:String = "StreamDeckButton";
  public final version:String = "3.0.0";
  public final author:String = "Danielo Rodríguez <rdanielo@gmail.com>";
  public final license:String = "MIT - https://opensource.org/licenses/MIT";
  public final homepage:String = "https://github.com/danielo515/StreamDeckButton.spoon";
  public final logger = Logger.make("StreamDeckButton", "debug");

  // Convenience accessors for external modules
  static final getImageMessage = Messages.getImageMessage;
  static final showOkMessage = Messages.showOkMessage;
  static final getTitleMessage = Messages.getTitleMessage;

  // Runtime
  public var contexts:Null< State > = null;
  public var server:Null< HttpServer >;

  public final keyDownSubscribers = new Map< MessageID, Array< Subscriber > >();
  public final willAppearSubscribers = new DynamicAccess< Array< Subscriber > >();

  static public function init():Void {}

  public function onKeyDown(id:MessageID, callback:Null< Subscriber >):Void {
    if (id == null || callback == null) {
      return;
    }
    final subscribers = switch (keyDownSubscribers[id]) {
      case null:
        final value = [];
        keyDownSubscribers[id] = value;
        value;
      case value if (value != null):
        value;
      case _:
        throw "This should never happen";
    }
    subscribers.push(callback);
  }

  public function onWillAppear(id:String, callback:Null< Subscriber >):Void {
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
      case Right(parsedMessage = {payload: {settings: s}, context: ctx, event: event}):
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
            var result:Null< Dynamic > = null;
            final subscribers = keyDownSubscribers[s.id];
            if (subscribers != null) {
              for (callback in subscribers) {
                result = callback(ctx, parsedMessage);
                logger.f("callback result %s", cast(result));
              }
            }
            result;
          case "willAppear":
            var result:Null< Dynamic > = null;
            if (willAppearSubscribers.exists(ctx)) {
              for (callback in willAppearSubscribers[ctx]) {
                result = callback(ctx, parsedMessage);
                logger.f("callback result %s", cast(result));
              }
            }
            result;
          case _:
            logger.f("Default case", (parsedMessage));
            Messages.showOkMessage(ctx);
        };
        logger.f("Sending response: %s", cast(response));
        return Json.encode(response.or(Messages.showOkMessage(ctx)));
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
  public function setImage(id:MessageID, imagePath:String) {
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
      server.setPort(port.or(3094));
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
