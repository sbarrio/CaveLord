package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class TitleState extends FlxState
{

	private var title:FlxSprite;
	private var monster:FlxSprite;
	private var monster2:FlxSprite;
	private var monster3:FlxSprite;
	private var pressStartText:FlxText;
	private var copyText:FlxText;
	private var textColor:Int = FlxColor.WHITE;
	private var spacePressed:Bool = false;

	override public function create():Void
	{
		super.create();

		bgColor = 0xFF01404E;

		title = new FlxSprite(40,40);
		title.loadGraphic(Reg.TITLE);
		add(title);

		monster = new FlxSprite(180,320);
		monster.loadGraphic(Reg.ROCKER,true,64,64,true);
		monster.animation.add("walk_down",[0,1],2,true);
		add(monster);

		monster2 = new FlxSprite(280,320);
		monster2.loadGraphic(Reg.ROCKER,true,64,64,true);
		monster2.animation.add("walk_down",[0,1],2,true);
		add(monster2);

		monster3 = new FlxSprite(380,320);
		monster3.loadGraphic(Reg.ROCKER,true,64,64,true);
		monster3.animation.add("walk_down",[0,1],2,true);
		add(monster3);

		monster.animation.play("walk_down");
		monster2.animation.play("walk_down");
		monster3.animation.play("walk_down");

		pressStartText = new FlxText(170,260,300,"Press SPACE to play");
		pressStartText.setFormat(Reg.MAIN_FONT, 45, textColor, "center");
		add(pressStartText);

		copyText = new FlxText(450,440,200,"LD33 - sbarrio 2015");
		copyText.setFormat(Reg.MAIN_FONT, 30, textColor, "center");
		add(copyText);

		FlxFlicker.flicker(pressStartText, 0, 0.5, false, false, null, null);
	}
	
	override public function update():Void
	{
		super.update();
		if (FlxG.keys.justPressed.SPACE && !spacePressed){
        	spacePressed = true;
			FlxFlicker.stopFlickering(pressStartText);
			FlxG.sound.play(Reg.SND_START_PRESSED,1,false,false,soundFinishedPlaying);
        }
	}	

	override public function destroy():Void
	{
		super.destroy();
	}

	private function soundFinishedPlaying():Void{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
    		FlxG.switchState(new IntroState());
		});
	}

}