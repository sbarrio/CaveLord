package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;

class TiledStage extends TiledMap
{
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	public var wallTiles:FlxGroup;

	//object groups
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		wallTiles = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
	
		// Load Tile Maps
		for (tileLayer in layers)
		{
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= Reg.PATH_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			if (tileLayer.name == "bg"){

				backgroundTiles.add(tilemap);	

			}else if (tileLayer.name == "fg"){

				foregroundTiles.add(tilemap);

			}else{	

				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				if (tileLayer.name == "wall"){
					wallTiles.add(tilemap);
				}
				
				collidableTileLayers.push(tilemap);
			}
		}
	}
	
	public function loadObjects(state:MapState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:MapState)
	{
		var x:Int = o.x;	
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "start":
				//creates player
				var player = new Player(x,y,1,15,5,5,5,5,0,state);
				state.player = player;
				state.add(player);
				
			case "enemy":
				 var level = Std.parseInt(o.custom.get("level"));
				 var name = o.custom.get("name");
				 var hp = Std.parseInt(o.custom.get("hp"));
				 var df = Std.parseInt(o.custom.get("df"));
				 var str = Std.parseInt(o.custom.get("str"));
				 var spd = Std.parseInt(o.custom.get("spd"));
				 var enemy = new Enemy(x,y,level,name,hp,df,str,spd,state);
				 if (state.enemies == null){
				 	state.enemies = new FlxTypedGroup<Enemy>();
				 	state.add(state.enemies);
				 }
				 state.enemies.add(enemy);
		}
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		var colliding:Bool = false;
		if (collidableTileLayers != null)
		{

			for (map in collidableTileLayers)
			{
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px).
				// if(FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
				if(FlxG.overlap(map, obj, null, FlxObject.separate))
				{
					colliding = colliding || true;
				}else{
					colliding = colliding || false;
				}
			}

		}
		return colliding;
	}

}