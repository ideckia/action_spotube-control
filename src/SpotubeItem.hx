package;

using api.IdeckiaApi;

typedef Props = {
	var ws:WebSocket;
	var icon:String;
	var action:String;
}

@:name("_spotube-item")
@:description("item_action_description")
@:localize
class SpotubeItem extends IdeckiaAction {
	override function init(initialState:ItemState):js.lib.Promise<ItemState> {
		initialState.icon = props.icon;
		return js.lib.Promise.resolve(initialState);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		props.ws.send(haxe.Json.stringify({type: props.action}));
		return js.lib.Promise.resolve(new ActionOutcome({state: currentState}));
	}
}
