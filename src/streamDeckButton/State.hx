package streamDeckButton;

import hammerspoon.Json;
import streamDeckButton.Data.StoredSettings;
import lua.Table.create as t;
import hammerspoon.Settings;

class State {
  private static var inst:Null< State > = null;
  private static final namespace = 'StreamDeckButton-hx';

  public final data:StoredSettings;

  function new(data:StoredSettings) {
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
      (t({}));
    } else {
      final parsedData = Json.decode(rawData);
      if (parsedData == null) {
        (t({}));
      } else {
        parsedData;
      }
    };
    inst = new State(new StoredSettings(parsedData));
    return inst;
  }

  public function store() {
    final jsonData = data.toJson();
    Settings.set(namespace, jsonData);
    trace('Saved it:', jsonData);
  }

  public function get(id:String) {
    return data.get(id);
  }

  public function exists(id:String):Bool {
    return data.exists(id);
  }

  public function addContext(id:String, context:String) {
    final check = data.get(id);
    check[context] = context;
    store();
  }
}
