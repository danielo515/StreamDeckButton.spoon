package streamDeckButton;

import hammerspoon.Json;
import lua.StringMap;
import hammerspoon.Settings;
import json2object.JsonWriter;
import json2object.JsonParser;

typedef Data = StringMap< StringMap< String > >;

class State {
  private static var inst:Null< State > = null;
  private static final namespace = 'StreamDeckButton-hx';
  private static final jsonWritter = new JsonWriter< Data >();
  private static final jsonReader = new JsonParser< Data >();

  public final data:Data;

  function new(data:Data) {
    this.data = data;
  }

  public static function getInstance():State {
    if (inst == null) {
      return init();
    }
    return inst;
  }

  public static function init():State {
    if (inst != null) {
      return inst;
    }
    final rawData = Settings.get(namespace);
    final parsedData = if (rawData == null) {
      new StringMap< StringMap< String > >();
    } else {
      jsonReader.fromJson(rawData, 'settings');
    };
    inst = new State(parsedData);
    return inst;
  }

  public function store() {
    Settings.set(namespace, jsonWritter.write(data));
    trace('Saved it');
  }

  public function get(id:String) {
    return data.get(id);
  }

  public function exists(id:String):Bool {
    return data.exists(id);
  }

  public function addContext(id:String, context:String) {
    final check = data.get(id);
    final existingContexts = if (check == null) {
      final newContext = new StringMap< String >();
      data.set(id, newContext);
      newContext;
    } else {
      check;
    };
    existingContexts.set('context', context);
    store();
  }
}
