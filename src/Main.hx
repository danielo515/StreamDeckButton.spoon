import hammerspoon.Hammerspoon.HttpServer;

@:expose
function start() {
	trace("Starting Server, nabo");
	final server = HttpServer.make(false, true);
}
