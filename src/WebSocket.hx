package;

@:jsRequire("ws", "WebSocket")
extern class WebSocket {
	public function new(url:String);
	dynamic public function onopen():Void;
	public function on(event:String, fb:Dynamic):Void;
	public function off(event:String, fb:Dynamic):Void;
	public function once(event:String, fb:Dynamic):Void;
	public function send(data:String):Void;
	public function terminate():Void;
}
