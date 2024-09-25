package;

using api.IdeckiaApi;

typedef Props = {
	var ws:WebSocket;
	var play_icon:String;
	var pause_icon:String;
}

@:name("_spotube-play-pause-item")
@:description("play_pause_action_description")
@:localize
class SpotubePlayPauseItem extends IdeckiaAction {
	var playing:Bool;
	var itemState:ItemState;

	function onMessage(msg:Dynamic) {
		var spResp:Types.SpotubeResponse = haxe.Json.parse(msg);
		switch spResp.type {
			case 'queue':
				var queue:Types.QueueData = cast spResp.data;
				playing = queue.playing;
				updateInfo(queue);
			case _:
		}
	}

	override function init(initialState:ItemState):js.lib.Promise<ItemState> {
		itemState = initialState;
		itemState.icon = props.play_icon;
		props.ws.on('message', onMessage);
		return js.lib.Promise.resolve(itemState);
	}

	override public function hide() {
		props.ws.off('message', onMessage);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			itemState = currentState;
			final action = playing ? 'pause' : 'resume';
			props.ws.send(haxe.Json.stringify({type: action}));
		});
	}

	function updateInfo(data:Types.QueueData) {
		final currentTrack = data.playlist.medias[data.playlist.index].extras.track;

		final artist = currentTrack.artists[0].name;
		final name = currentTrack.name;

		itemState.text = '{b:${artist}}\n${name}';
		itemState.icon = playing ? props.pause_icon : props.play_icon;

		core.updateClientState(itemState);
	}
}
