package;

using api.IdeckiaApi;

typedef Props = {}

@:name("spotube-control")
@:description("control_action_description")
@:localize("loc")
class SpotubeControl extends IdeckiaAction {
	static var ICON = Data.embedBase64('img/spotube_logo.png');
	static var PREVIOUS = Data.embedBase64('img/previous.png');
	static var NEXT = Data.embedBase64('img/next.png');
	static var PLAY = Data.embedBase64('img/play.png');
	static var PAUSE = Data.embedBase64('img/pause.png');

	var spotubePort:UInt = null;
	var ws:WebSocket;

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		var runtimeImg = core.data.getBase64('img/spotube_logo.png');
		if (runtimeImg != null)
			ICON = runtimeImg;
		runtimeImg = core.data.getBase64('img/previous.png');
		if (runtimeImg != null)
			PREVIOUS = runtimeImg;
		runtimeImg = core.data.getBase64('img/next.png');
		if (runtimeImg != null)
			NEXT = runtimeImg;
		runtimeImg = core.data.getBase64('img/play.png');
		if (runtimeImg != null)
			PLAY = runtimeImg;
		runtimeImg = core.data.getBase64('img/pause.png');
		if (runtimeImg != null)
			PAUSE = runtimeImg;

		initialState.icon = ICON;

		return super.init(initialState);
	}

	function returnDirectory() {
		var dynamicDir:DynamicDir = {
			rows: 2,
			columns: 2,
			items: [
				{
					textColor: 'ff333333',
					actions: [
						{
							name: '_spotube-now-playing-item',
							props: {
								ws: ws
							}
						}
					]
				},
				{
					text: 'paused',
					icon: PLAY,
					actions: [
						{
							name: '_spotube-play-pause-item',
							props: {
								ws: ws,
								play_icon: PLAY,
								pause_icon: PAUSE,
							}
						}
					]
				},
				{
					icon: PREVIOUS,
					actions: [
						{
							name: '_spotube-item',
							props: {
								ws: ws,
								icon: PREVIOUS,
								action: 'previous'
							}
						}
					]
				},
				{
					icon: NEXT,
					actions: [
						{
							name: '_spotube-item',
							props: {
								ws: ws,
								icon: NEXT,
								action: 'next'
							}
						}
					]
				}
			]
		}
		return new ActionOutcome({directory: dynamicDir});
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			var portFound = false;
			lookForPort().then(_ -> {
				portFound = true;
				resolve(returnDirectory());
			});

			haxe.Timer.delay(() -> {
				if (!portFound)
					core.dialog.error(Loc.connect_error_title.tr(), Loc.connect_error_body.tr());
			}, 2000);
		});
	}

	function connect(resolve:Dynamic) {
		if (ws != null)
			ws.terminate();

		ws = new WebSocket('ws://0.0.0.0:${spotubePort}/ws');
		ws.once('open', () -> {
			trace('Connected to Spotube');
			resolve(spotubePort);
		});
		ws.once('close', () -> {
			trace('Disconnected from Spotube');
			core.dialog.error(Loc.disconnected_title.tr(), Loc.disconnected_body.tr());
		});
	}

	function lookForPort() {
		return new js.lib.Promise((resolve, reject) -> {
			function checkPort() {
				for (i in 5001...22500)
					CallHttp.ping(i).then(p -> {
						if (p != -1) {
							spotubePort = p;
							core.log.debug('Spotube port found [$spotubePort]');
							connect(resolve);
							return;
						}
					}).catchError(_ -> {});
			}

			if (spotubePort != null)
				CallHttp.ping(spotubePort).then(_ -> connect(resolve)).catchError(_ -> checkPort());
			else
				checkPort();
		});
	}
}
