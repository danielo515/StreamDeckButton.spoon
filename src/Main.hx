import hammerspoon.Hammerspoon as Hs;

@:expose
function start() {
	trace("Starting Server, nabo");
	final server = Hs.httpserver.make(false, true);
}
