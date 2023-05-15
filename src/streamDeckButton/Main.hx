package streamDeckButton;

import haxe.macro.Context.Message;
import lua.Table;
import lua.Table.create as t;
import hammerspoon.Settings;
import hammerspoon.Json;
import hammerspoon.Logger;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.DynamicAccess;

typedef StringTable< T > = Table< String, T >;

abstract Dict(StringTable< String >) from StringTable< String > to StringTable< String > {
  inline public function new(args) {
    this = args;
  }

  @:arrayAccess
  inline public function set(key:String, value:String):Void {
    Reflect.setField(this, key, value);
  }
}

abstract StoredSettings(StringTable< Dict >) from StringTable< Dict > to StringTable< Dict > {
  inline public function new(args) {
    this = args;
  }

  @:arrayAccess
  inline public function get(key:String):Dict {
    final value = Reflect.field(this, key);
    if (value == null) {
      Reflect.setField(this, key, new Dict(t()));
      return get(key);
    }
    return value;
  }

  @:arrayAccess
  inline public function set(key:String, value:Dict):Void {
    Reflect.setField(this, key, value);
  }
}

@:expose("StreamDeckButton")
class StreamDeckButton {
  public static var Events = {
    keyDown: "keyDown",
    willAppear: "willAppear",
    willDisappear: "willDisappear",
    keyUp: "keyUp"
  };

  public final name:String = "StreamDeckButton";
  public final settingsPath:String = "streamDeckButton";
  public final version:String = "3.0.0";
  public final author:String = "Danielo Rodríguez <rdanielo@gmail.com>";
  public final license:String = "MIT - https://opensource.org/licenses/MIT";
  public final homepage:String = "https://github.com/danielo515/StreamDeckButton.spoon";
  public final logger = Logger.make("StreamDeckButton", "debug");
  public final contexts:DynamicAccess< Dynamic > = new DynamicAccess< Dynamic >();

  // TODO: Implement the following functions as separate Haxe modules:
  // - utilities.getValueForKeyPath
  // - msg.getImageMessage
  // - msg.getTitleMessage
  // - msg.showOkMessage
  //  public var getImageMessage:Dynamic;
  // public var getTitleMessage:Dynamic;
  // public var showOkMessage:Dynamic;
  public var keyDownSubscribers:DynamicAccess< Array< Dynamic > > = new DynamicAccess< Array< Dynamic > >();
  public var willAppearSubscribers:DynamicAccess< Array< Dynamic > > = new DynamicAccess< Array< Dynamic > >();

  public function getSettings():StoredSettings {
    final readSettings = Settings.get(name);
    final settings = readSettings != null ? readSettings : Table.create();
    return settings;
  }

  public function storeInSettings(id:String, context:String):Void {
    final settings = getSettings();
    settings[id][context] = context;
    Settings.set(name, settings);
    logger.df("Settings: %s", Std.string(settings));
  }

  public function init():Void {
    var settings = getSettings();
    for (id in Reflect.fields(settings)) {
      var contexts = settings[id];
      logger.df("Restoring context for id %s %s", id, Std.string(contexts));
      this.contexts[id] = contexts;
    }
  }

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
    var params = Json.decode(message);
    if (params == null) {
      logger.e("params is nil");
      logger.d("message: " + message);
      return null;
    }
    logger.d("decoded message: " + Std.string(params));

    var event = params.event;
    if (event == null) {
      logger.e("event is nil");
      return null;
    }

    var id = params.payload!.settings!.id;
    if (id == null) {
      logger.e("id is nil");
      return null;
    }
    if (contexts[id] == null) {
      logger.f("new id found: %s with this context: %s", id, params.context);
      setTitle(id, "Not loaded", params.context);
      contexts[id] = {
        [params.context] = true;
      };
    }
    contexts[id][params.context] = true;
    storeInSettings(id, params.context);

    if (contexts[id] == null) {
      logger.e("contexts[id] is nil for id: %s", id);
      return null;
    }

    var response = {};
    if (event == "keyDown") {
      if (keyDownSubscribers.exists(id)) {
        for (callback in keyDownSubscribers[id]) {
          response = callback(params.context, params);
        }
      }
    } else if (event == "willAppear") {
      if (willAppearSubscribers.exists(id)) {
        for (callback in willAppearSubscribers[id]) {
          response = callback(params.context, params);
        }
      }
    }

    if (response == null) {
      response = showOkMessage(contexts[id]);
    }

    return Json.encode(response);
  }

  // TODO: Implement the following methods using the Haxe modules mentioned above:
  // - setTitle
  // - setImage
  // - start
  // - stop
}
