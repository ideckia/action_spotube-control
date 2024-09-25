class CallHttp {
	public static function callEndpoint(endpoint:String, post:Bool = false) {
		return new js.lib.Promise((resolve, reject) -> {
			var http = new haxe.Http(endpoint);
			http.addHeader('Accept', 'application/json');
			http.onError = reject;
			http.onBytes = resolve;
			http.request(post);
		});
	}

	public static function ping(port:Int) {
		return new js.lib.Promise<Int>((resolve, reject) -> {
			var http = new haxe.Http('http://0.0.0.0:${port}/ping');
			http.onError = reject;
			http.onData = d -> if (d == 'pong') resolve(port) else resolve(-1);
			http.request();
		});
	}
}
