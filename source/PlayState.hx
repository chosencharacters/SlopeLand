package;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.math.FlxPoint;
import zero.flixel.utilities.Dolly;

class PlayState extends FlxState
{
	var slopeBoy:FlxSprite;
	var slopeWorld:FlxTilemapExt;
	var dolly:Dolly;
	
	var speed:Int = 150;
	
	override public function create():Void
	{
		createSlopeWorld();
		createSlopeBoy();
		addDolly();
		super.create();
	}
	
	function createSlopeBoy(){
		slopeBoy = new FlxSprite(0, slopeWorld.y + slopeWorld.height - 32 - 23);
		slopeBoy.makeGraphic(19, 23);
		slopeBoy.acceleration.y = 400;
		slopeBoy.maxVelocity.set(200, 400);
		slopeBoy.drag.x = slopeBoy.maxVelocity.x /4;
		add(slopeBoy);
	}
	
	function createSlopeWorld(){
		var loader:FlxOgmo3LoaderExt = new FlxOgmo3LoaderExt("assets/data/SlopeLand.ogmo", "assets/data/SlopeWorld.json");
		slopeWorld = loader.loadTilemapExt(AssetPaths.collision__png, "tiles");
		slopeWorld.setSlopes([2], [3], [4], [5]);
		slopeWorld.setDownwardsGlue(true);
		
		FlxG.worldBounds.set(slopeWorld.width, slopeWorld.height);
		
		add(slopeWorld);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(slopeBoy, slopeWorld);
		controlSlopeBoy();
		super.update(elapsed);
	}
	
	var crouch_timer = 0;
	function controlSlopeBoy(){
		if (FlxG.keys.anyPressed(["RIGHT", "D"])){
			slopeBoy.velocity.x += speed / 10;
			// slopeBoy.acceleration.x = slopeBoy.maxVelocity.x * ((slopeBoy.isTouching(FlxObject.FLOOR)) ? 4 : 3);
			// if(slopeBoy.velocity.x > slopeBoy.maxVelocity.x) slopeBoy.velocity.x = slopeBoy.maxVelocity.x;
		}
		if (FlxG.keys.anyPressed(["LEFT", "A"])){
			slopeBoy.velocity.x -= speed / 10;
			// slopeBoy.acceleration.x = -slopeBoy.maxVelocity.x * ((slopeBoy.isTouching(FlxObject.FLOOR)) ? 4 : 3);
			// if(slopeBoy.velocity.x < slopeBoy.maxVelocity.x*-1) slopeBoy.velocity.x = slopeBoy.maxVelocity.x*-1;
		}
		if (FlxG.keys.anyJustPressed(["UP", "Z", "SPACE", "W"]) && slopeBoy.isTouching(FlxObject.FLOOR)){
			slopeBoy.velocity.y = -235;
		}
		slopeBoy.velocity.x *= 0.95;

		if (FlxG.keys.anyPressed(['DOWN', 'S']) && slopeBoy.isTouching(FlxObject.FLOOR)) {
			FlxG.camera.targetOffset.y += ((crouch_timer-- > 0 ? 0 : 64) - FlxG.camera.targetOffset.y) * 0.1;
		}
		else {
			crouch_timer = 30;
			FlxG.camera.targetOffset.y += (0 - FlxG.camera.targetOffset.y) * 0.1;
		}

		if (FlxG.keys.justPressed.T) teleport(80, 185);
	}
	
	function addDolly(){
		var startDollyPos:FlxPoint;
		var introStarted:Bool = false;
		
		var scrollAdjust:Int = 0;
		
		//<DOLLY SET>
		if (dolly == null){
			var maxDelta:Float = 3;
			var lerp:Float = 0.5;
			
			var forwardFocusOffset:Float = 32;
			/***Note - Higher Number = Farther From the Ground***/
			var platformOffset:Int = 32;
			
			dolly = new Dolly({
				target:slopeBoy,
				lerp: {x:0.075, y:0.75} //formerly 0.1 0.1 changed on 5/20/2020
			});
			
			dolly.add_component(new BoundsOverride({ rects: [new AreaRect(0, FlxG.height/2 + 8, FlxG.width * 2, FlxG.height)], tilemap: slopeWorld }));
			dolly.add_component(new WindowConstraint({width: FlxG.width * 0.25, height: FlxG.height * 0.6})); //.75 -> .5 -> .25
			dolly.add_component(new ForwardFocus({ offset: forwardFocusOffset, threshold:  48})); //48 //80
			dolly.add_component(new PlatformSnap({ offset: platformOffset, lerp: 0.1, max_speed: 100 }));
			
			add(dolly);
			FlxG.camera.follow(dolly);
		}
	}

	function teleport(x:Float, y:Float) {
		slopeBoy.setPosition(x, y);
		dolly.set_target(slopeBoy, true);
	}
}
