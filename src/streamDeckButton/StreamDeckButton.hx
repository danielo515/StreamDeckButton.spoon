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
  // Don't make them static because external code gets an instance, not the class
  public final getImageMessage = Messages.getImageMessage;
  public final showOkMessage = Messages.showOkMessage;
  public final getTitleMessage = Messages.getTitleMessage;

  // Runtime
  public var contexts:Null< State > = null;
  public var server:Null< HttpServer >;

  public final keyDownSubscribers = new Map< MessageID, Array< Subscriber > >();
  public final willAppearSubscribers = new Map< MessageID, Array< Subscriber > >();

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

  public function onWillAppear(id:MessageID, callback:Null< Subscriber >):Void {
    if (id == null || callback == null) {
      return;
    }
    final subscribers = switch (willAppearSubscribers[id]) {
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

        final subscribers:Array< Subscriber > = switch (event) {
          case "keyDown":
            final subscribers = keyDownSubscribers[s.id];
            if (subscribers != null) {
              subscribers;
            } else {
              logger.f("No subscribers for keyDown event");
              [];
            }
          case "willAppear":
            final subscribers = willAppearSubscribers[s.id];
            if (subscribers != null) {
              subscribers;
            } else {
              logger.f("No subscribers for appear event");
              [];
            }
          case _: [];
        };
        var response:Null< Dynamic > = null;

        for (callback in subscribers) {
          response = callback(ctx, parsedMessage);
          logger.f("callback result %s", cast(response));
        }
        logger.f("Sending response: %s", cast(response));
        return if (response != null) {
          Json.encode(response);
        } else Json.encode(Messages.showOkMessage(ctx));
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
