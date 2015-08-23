package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;

class GameOverState extends FlxState
{

	private var textColor:Int = FlxColor.WHITE;
	private var buttonPressed:Bool = false;

	override public function create():Void
	{
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, .33, true);    

		var endText = new FlxText(0,150,FlxG.width,"YOU ARE DEAD");
		endText.setFormat(Reg.MAIN_FONT,50,textColor,"center", 1, textColor);
		add(endText);

		var imgGameOver = new FlxSprite(255,190);
		imgGameOver.loadGraphic(Reg.GAMEOVER);
		add(imgGameOver);

		var pressButtonText = new FlxText(0,330,FlxG.width,"Press SPACE");
		pressButtonText.setFormat(Reg.MAIN_FONT,35,textColor,"center",1,textColor);
		add(pressButtonText);

		FlxFlicker.flicker(pressButtonText, 0, 0.5, false, false, null, null);
	}
	
	override public function update():Void
	{
		super.update();

		if (buttonPressed == false && FlxG.keys.pressed.SPACE){
			buttonPressed = true;
			goToTitleState();	
		}
	}	

	override public function destroy():Void
	{
		super.destroy();
	}

	private function goToTitleState():Void{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {			
    		FlxG.switchState(new TitleState());
		});
	}
}