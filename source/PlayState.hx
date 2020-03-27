package;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class PlayState extends FlxState
{
	var slopeBoy:FlxSprite;
	var slopeWorld:FlxTilemapExt;
	
	var speed:Int = 125;
	
	override public function create():Void
	{
		createSlopeBoy();
		createSlopeWorld();
		super.create();
	}
	
	function createSlopeBoy(){
		slopeBoy = new FlxSprite(0, 0);
		slopeBoy.makeGraphic(19, 23);
		slopeBoy.acceleration.y = 300;
		slopeBoy.drag.x = 50;
		add(slopeBoy);
	}
	
	function createSlopeWorld(){
		var loader:FlxOgmo3LoaderExt = new FlxOgmo3LoaderExt("assets/data/SlopeLand.ogmo", "assets/data/SlopeWorld.json");
		slopeWorld = loader.loadTilemapExt(AssetPaths.collision__png, "tiles");
		slopeWorld.setSlopes([2], [3], [4], [5]);
		add(slopeWorld);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(slopeBoy, slopeWorld);
		controlSlopeBoy();
		super.update(elapsed);
	}
	
	function controlSlopeBoy(){
		if (FlxG.keys.anyPressed(["RIGHT", "D"])){
			slopeBoy.velocity.x += speed / 15;
		}
		if (FlxG.keys.anyPressed(["LEFT", "A"])){
			slopeBoy.velocity.x -= speed / 15;
		}
		if (FlxG.keys.anyJustPressed(["UP", "Z", "SPACE", "W"]) && slopeBoy.isTouching(FlxObject.FLOOR)){
			slopeBoy.velocity.y = -235;
		}
	}
}
