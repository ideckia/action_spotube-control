typedef Types = {}

typedef SpotubeResponse = {
	var type:String;
	var ?data:Any;
}

enum abstract SpotubeResponseType(String) from String {
	var queue;
}

typedef QueueData = {
	var playing:Bool;
	var loopMode:String;
	var shuffled:Bool;
	var playlist:Playlist;
	var collections:Array<String>;
}

typedef Playlist = {
	var medias:Array<Media>;
	var index:UInt;
}

typedef Media = {
	var uri:String;
	var extras:{track:Track};
}

typedef Track = {
	var name:String;
	var album:Album;
	var artists:Array<Artist>;
}

typedef Album = {
	var name:String;
	var release_date:String;
	var artists:Array<Artist>;
	var images:Array<Image>;
}

typedef Artist = {
	var id:String;
	var name:String;
}

typedef Image = {
	var height:Int;
	var width:Int;
	var url:String;
}
