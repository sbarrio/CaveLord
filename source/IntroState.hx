package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class IntroState extends FlxState
{
	private var buttonPressed:Bool = false;
	private var textColor:Int = FlxColor.WHITE;

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF01404E;

		var storyText = new FlxText(0,20,FlxG.width,"You are the lord of the cave. \n One day, you receive a letter, warning you of a mighty hero that will come and attempt \n to slay you in 3 DAYS. \n\n You must now train as hard as you can to be prepared to meet your destiny!");
		storyText.setFormat(Reg.MAIN_FONT,45,textColor,"center");
		add(storyText);

		var boss = new FlxSprite(255,295);
		boss.loadGraphic(Reg.PLAYER, true, 128, 128,true);
		add(boss);

		boss.animation.add("walk_down",[2,3],8,true);
		boss.animation.play("walk_down");

		var pressButtonText = new FlxText(0,430,FlxG.width,"Press SPACE");
		pressButtonText.setFormat(Reg.MAIN_FONT,35,textColor,"center",1,textColor);
		add(pressButtonText);

		FlxFlicker.flicker(pressButtonText, 0, 0.5, false, false, null, null);
	}
	
	override public function update():Void
	{
		super.update();

		if (buttonPressed == false && FlxG.keys.pressed.SPACE){
			buttonPressed = true;
			goToMapState();	
			FlxG.sound.play(Reg.SND_START_PRESSED);
		}
		
	}	

	override public function destroy():Void
	{
		super.destroy();
	}

	private function goToMapState():Void{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
			var state = new MapState();
			state.MapStateConfig(null,1,0.07);
    		FlxG.switchState(state);
		});
	}
}