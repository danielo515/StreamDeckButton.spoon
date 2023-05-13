import hammerspoon.Hammerspoon.Json;
import hammerspoon.Hammerspoon.Alert;
import hammerspoon.Hammerspoon.HttpServer;

@:expose("start")
function start() {
  trace("Starting Server, nabo");
  final server = HttpServer.make(false, true);
  Alert.show('Server started');
  final test = Json.encode({a: 1, b: 2});
  trace(test);
}
