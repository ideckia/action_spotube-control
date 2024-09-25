package;

import Types.QueueData;

using api.IdeckiaApi;

typedef Props = {
	var ws:WebSocket;
}

@:name("_spotube-now-playing-item")
@:description("now_playing_action_description")
@:localize
class SpotubeNowPlayingItem extends IdeckiaAction {
	var prevArtist = 'artist';
	var prevName = 'name';
	var itemState:ItemState;

	function onMessage(msg:Dynamic) {
		var spResp:Types.SpotubeResponse = haxe.Json.parse(msg);
		switch spResp.type {
			case 'queue':
				var queue:Types.QueueData = cast spResp.data;
				updateInfo(queue);
			case _:
		}
	}

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		itemState = initialState;
		props.ws.on('message', onMessage);

		return js.lib.Promise.resolve(itemState);
	}

	override public function hide() {
		props.ws.off('message', onMessage);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome>
		return js.lib.Promise.resolve(new ActionOutcome({state: currentState}));

	function updateInfo(data:Types.QueueData) {
		final currentTrack = data.playlist.medias[data.playlist.index].extras.track;

		if (currentTrack.artists[0].name == prevArtist && currentTrack.name == prevName)
			return;

		prevArtist = currentTrack.artists[0].name;
		prevName = currentTrack.name;

		final images = currentTrack.album.images;

		if (images == null || images.length == 0) {
			itemState.text = '{b:${prevArtist}}\n${prevName}';
			core.updateClientState(itemState);
			return;
		}

		CallHttp.callEndpoint(images[0].url)
			.then(data -> itemState.icon = haxe.crypto.Base64.encode(data))
			.catchError(e -> {
				core.log.error('Error getting ${images[0].url} thumbnail: $e');
				itemState.text = '{b:${prevArtist}}\n${prevName}';
			})
			.finally(() -> core.updateClientState(itemState));
	}
}
