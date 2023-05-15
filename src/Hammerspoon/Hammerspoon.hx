package hammerspoon;

@:native("hs.httpserver")
extern class HttpServer {
  @:native("new") @:luaDotMethod static public function make(ssl:Bool, bonjour:Bool):HttpServer;
  public function getInterface():Null< String >;
  public function getName():String;
  public function getPort():Int;
  public function maxBodySize(size:Int):Dynamic;
  public function send(message:String):Void;
  public function setCallback(callback:Dynamic):Void;
  public function setInterface(interfaceName:String):Void;
  public function setName(name:String):Void;
  public function setPassword(password:String):Void;
  public function setPort(port:Int):Void;
  public function start():Void;
  public function stop():Void;
  public function websocket(path:String, callback:Dynamic):Void;
}

@:native("hs.json")
extern class Json {
  /**
   * Decodes JSON into a table
   *
   * Parameters:
   *  * jsonString - A string containing some JSON data
   *
   * Returns:
   *  * A table representing the supplied JSON data
   *
   * Notes:
   *  * This is useful for retrieving some of the more complex lua table structures as a persistent setting (see `hs.settings`)
   */
  @:luaDotMethod static public function decode(jsonString:String):Dynamic;

  /**
   * Encodes a table as JSON
   *
   * Parameters:
   *  * val         - A table containing data to be encoded as JSON
   *  * prettyprint - An optional boolean, true to format the JSON for human readability, false to format the JSON for size efficiency. Defaults to false
   *
   * Returns:
   *  * A string containing a JSON representation of the supplied table
   *
   * Notes:
   *  * This is useful for storing some of the more complex lua table structures as a persistent setting (see `hs.settings`)
   */
  @:luaDotMethod static public function encode(val:Dynamic, ?prettyprint:Bool):String;

  /**
   * Decodes JSON file into a table.
   *
   * Parameters:
   *  * path - The path and filename of the JSON file to read.
   *
   * Returns:
   *  * A table representing the supplied JSON data, or `nil` if an error occurs.
   */
  @:luaDotMethod static public function read(path:String):Dynamic;

  /**
   * Encodes a table as JSON to a file
   *
   * Parameters:
   *  * data       - A table containing data to be encoded as JSON
   *  * path       - The path and filename of the JSON file to write to
   *  * prettyprint - An optional boolean, `true` to format the JSON for human readability, `false` to format the JSON for size efficiency. Defaults to `false`
   *  * replace     - An optional boolean, `true` to replace an existing file at the same path if one exists. Defaults to `false`
   *
   * Returns:
   *  * `true` if successful otherwise `false` if an error has occurred
   */
  @:luaDotMethod static public function write(data:Dynamic, path:String, ?prettyprint:Bool, ?replace:Bool):Bool;
}
