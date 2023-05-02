package hammerspoon;

@:native("httpserver")
extern class Ht {
	@:native("new") @:luaDotMethod public function make(ssl:Bool, bonjour:Bool):HttpServer;
}

@:native("httpserver")
extern class HttpServer {
	public function getInterface():Null<String>;
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

@:native("hs")
extern class Hammerspoon {
	public static final httpserver:Ht;
}
