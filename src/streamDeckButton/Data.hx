package streamDeckButton;

import hammerspoon.Json;
import lua.Table;
import lua.Lua;
import lua.Table.create as t;

class TableIterator< T > {
  static public function keys(obj):Iterator< String > {
    var next = Lua.next;
    var cur = next(obj, null).index;
    return {
      next: function() {
        var ret = cur;
        cur = next(obj, cur).index;
        return cast ret;
      },
      hasNext: function() return cur != null
    }
  }

  static public function iterator< T >(obj):Iterator< T > {
    var it = keys(obj);
    return untyped {
      hasNext: function() return it.hasNext(),
      next: function() return h[it.next()]
    };
  }
}

typedef StringTable< T > = Table< String, T >;

abstract Dict(StringTable< String >) from StringTable< String > to StringTable< String > {
  inline public function new(args) {
    this = args;
  }

  @:arrayAccess
  inline public function set(key:String, value:String):Void {
    Reflect.setField(this, key, value);
  }

  public function iterator():Iterator< String > {
    return TableIterator.iterator(this);
  }
}

/**
  Light wrapper around a table of tables.
  Compiles to clean lua
 */
abstract StoredSettings(StringTable< Dict >) from StringTable< Dict > to StringTable< Dict > {
  inline public function new(args) {
    this = args;
  }

  /**
    If the namesppace does not exist, it will be created.
   */
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

  inline public function toJson():String {
    return Json.encode(this);
  }

  inline public function exists(id:String):Bool {
    return Reflect.field(this, id) != null;
  }
}
