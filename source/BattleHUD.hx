package;

import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flixel.addons.effects.FlxWaveSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
using flixel.util.FlxSpriteUtil;


class BattleHUD extends FlxTypedGroup<FlxSprite>
{

	private var bg:FlxSprite;

	//BATTLE VARS
	private var playerTurn = true;
	private var p:Player;
	private var e:Enemy;
	private var playerGoesFirst:Bool = false;
	private var wait = false;
	private var battleFinished:Bool = false;

	private var playerExtraDF:Int = 0;
	private var enemyExtraDF:Int = 0;

	private var state:MapState;

	//HUD
	private var hudX:Float;
	private var hudY:Float;

	private var messageText:FlxText;
	private var fightText:FlxText;
	private var defendText:FlxText;
	private var techText:FlxText;
	private var healText:FlxText;

	private var HPmeter:FlxText;
	private var MPmeter:FlxText;

	private var textColor:Int = FlxColor.WHITE;

	private var enemyPortrait:FlxSprite;
	private var selector:FlxSprite;

	private var messageTimer:FlxTimer;
	
	public function new(State:MapState) 
	{
		super();		
		
		state = State;

		hudX = FlxG.camera.scroll.x;
		hudY = FlxG.camera.scroll.y;
	
		bg = new FlxSprite(0,0);
		bg.loadGraphic(Reg.BG_BATTLE,false,FlxG.width,FlxG.height);
		bg.x = hudX;
		bg.y = hudY;
		add(bg);

		//Texts
		fightText = new FlxText(hudX + 270,hudY + 320,100,"FIGHT");
		fightText.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(fightText);

		techText = new FlxText(hudX + 270,hudY + 380,100,"TECH");
		techText.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(techText);

		defendText = new FlxText(hudX + 450, hudY + 320,100,"DEFEND");
		defendText.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(defendText);

		healText = new FlxText(hudX + 450, hudY + 380,100,"HEAL");
		healText.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(healText);

		HPmeter = new FlxText(hudX + 60, hudY + 320,120,"HP - 0");
		HPmeter.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(HPmeter);

		MPmeter = new FlxText(hudX + 60, hudY + 380,120,"MP - 0");
		MPmeter.setFormat(Reg.MAIN_FONT,45,textColor,"center",1,textColor);
		add(MPmeter);


		messageText = new FlxText(hudX + 100,hudY + 60,450,"Message box test long messge is long am i there yet?");
		messageText.setFormat(Reg.MAIN_FONT,28,textColor,"left");
		add(messageText);

		//selector
		selector = new FlxSprite(fightText.x,fightText.y);
		selector.loadGraphic(Reg.SELECTOR);
		add(selector);
	}


	//Control
	public function selectorUp(){
		if (selector.y == techText.y){
			selector.y = defendText.y;
			FlxG.sound.play(Reg.SND_SELECTOR_MOVED,1,false,true);
		}
	}

	public function selectorRight(){
		if (selector.x == fightText.x){
			selector.x = defendText.x;
			FlxG.sound.play(Reg.SND_SELECTOR_MOVED,1,false,true);
		}
	}	
	
	public function selectorDown(){
		if (selector.y == defendText.y){
			selector.y = techText.y;
			FlxG.sound.play(Reg.SND_SELECTOR_MOVED,1,false,true);
		}
	}

	public function selectorLeft(){
		if (selector.x == defendText.x){
			selector.x = fightText.x;
			FlxG.sound.play(Reg.SND_SELECTOR_MOVED,1,false,true);
		}
	}

	//Battle check
	public function isPlayerTurn():Bool{
		return playerTurn;
	}

	public function initBattle(player:Player,enemy:Enemy){

        FlxG.sound.playMusic(Reg.MUS_BATTLE,1,true);
		enemyPortrait = new FlxSprite(0,0);

		enemyPortrait = enemy.loadGraphicFromSprite(enemy);
		enemyPortrait.x = hudX + 300;
		enemyPortrait.y = hudY + 200;
		add(enemyPortrait);

		p = player;
		e = enemy;

		messageText.text = e.name + " appeared!";

		if (player.spd >= enemy.spd){
			// trace("player first");
			playerTurn = true;
			wait = false;
		}else{
			// trace("player second");
			playerTurn = false;
			wait = true;
		}

		updatePlayerHUD();
	}

	override public function update():Void 
	{
		if (!battleFinished){
			if (p.health <= 0){
				p.health = 0;
				battleLost();
			}

			if (e.health <= 0){
				e.health = 0;
				battleWon();
			}

			if (!wait)
			{	
				if (playerTurn){
					showActionSelector();
					 if (FlxG.keys.pressed.LEFT)
		        	{   
		            	selectorLeft();
		        	}

		        	if (FlxG.keys.pressed.RIGHT)
		        	{   
		            	selectorRight();
		        	}

		        	if (FlxG.keys.pressed.UP)
		        	{   
		            	selectorUp();
		        	}

		        	if (FlxG.keys.pressed.DOWN)
		        	{   
		            	selectorDown();
		        	}

					// check to see any keys are pressed and set the cooresponding flags.
					if (FlxG.keys.justReleased.SPACE)
					{
						executeActionSelected();
					}
				}else{
					hideActionSelector();
				}		

			}else{
				//we are waiting

				hideActionSelector();
				if (isPlayerTurn() == false){
					//enemy turn

					if (e.name == "Rocker"){

            			var i = FlxRandom.intRanged(0,1);
            			switch (i) {
            				case 0:
            					if (FlxRandom.chanceRoll()){
            						var dmg = 0;
									if (p.df + playerExtraDF > e.str){
										p.health -= e.str -1;
										dmg = e.str -1;
									}else{
										p.health -= e.str;
										dmg = e.str;
									}
									
									messageText.text = e.name + " attacked and did " + dmg + " DMG!";
									FlxG.sound.play(Reg.SND_HURT_PLAYER);
            					}else{
            						messageText.text = e.name + " attacked... but it missed.";
            						FlxG.sound.play(Reg.SND_FAIL);
            					}
            				case 1:
								messageText.text = e.name + " is confused by your attack.";
            			}
					}

					if (e.name == "Mad Crab"){
							var i = FlxRandom.intRanged(0,3);
	            			switch (i) {
	            				case 0:
	            					if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str -1;
											dmg = e.str -1;
										}else{
											p.health -= e.str;
											dmg = e.str;
										}
										
										messageText.text = e.name + " attacked and did " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " attacked... but it missed.";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 1:
									messageText.text = e.name + " is really, REALLY mad at you.";
								case 2:
									if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str;
											dmg = e.str -1;
										}else{
											p.health -= e.str + 2;
											dmg = e.str;
										}
										
										messageText.text = e.name + " used its pincers!, " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " used its pincers... but it missed.";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 3: 
	            					messageText.text = e.name + " is cursing in a low voice.";
	            			}
					}

					if (e.name == "Vampire Cat"){
							var i = FlxRandom.intRanged(0,3);
	            			switch (i) {
	            				case 0:
	            					if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str -1;
											dmg = e.str -1;
										}else{
											p.health -= e.str;
											dmg = e.str;
										}
										
										messageText.text = e.name + " attacked and did " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " attacked... but it missed.";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 1:
									messageText.text = e.name + " is distracted chasing a fly.";
								case 2:
									if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str;
											dmg = e.str;
										}else{
											p.health -= e.str;
											dmg = e.str + 4;
										}
										
										messageText.text = e.name + " slashed with its claws!, " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " slashed with its claws!... barely missed!";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 3: 
	            					messageText.text = e.name + " meows in a zombified way...";
	            			}
					}

					if (e.name == "Hero"){
							var i = FlxRandom.intRanged(0,5);
	            			switch (i) {
	            				case 0:
	            					if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str -1;
											dmg = e.str -1;
										}else{
											p.health -= e.str;
											dmg = e.str;
										}
										
										messageText.text = e.name + " attacked and did " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " attacked... but he missed.";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 1:
									messageText.text = e.name + ": 'I grinded so long for this...'";
								case 2:
									if (FlxRandom.chanceRoll()){
	            						var dmg = 0;
										if (p.df + playerExtraDF > e.str){
											p.health -= e.str;
											dmg = e.str;
										}else{
											p.health -= e.str;
											dmg = e.str + 4;
										}
										
										messageText.text = e.name + " used his secret sword art!, " + dmg + " DMG!";
										FlxG.sound.play(Reg.SND_HURT_PLAYER);
	            					}else{
	            						messageText.text = e.name + " used his secret sword art!... but it missed!";
	            						FlxG.sound.play(Reg.SND_FAIL);
	            					}
	            				case 3: 
	            					messageText.text = e.name + ": 'I will free the world of your evilness!'";
	            				case 4: 
	            					messageText.text = e.name + ": 'I hope the princess is here...'";
	            				case 5:
	            					if (FlxRandom.chanceRoll()){
	            						messageText.text = e.name + " used a healing herb, recovered 5HP!";
	            						e.health += 5;
									}else{
										messageText.text = e.name + " used a healing herb, but it was rotten.";
									}
	            			}
					}

					playerTurn = true;

					//message Timer
					if (messageTimer != null){
						messageTimer.cancel();
						messageTimer = null;
					}
					messageTimer = new FlxTimer(1.5,enemyTurnFinished,0);
				}
			}
		}

		updatePlayerHUD();

		super.update();
	}

	private function battleLost():Void{
		// trace("battle lost");

		if (battleFinished){
			return;
		}

		FlxG.sound.play(Reg.SND_PLAYER_DEAD);

		battleFinished = true;
		wait = true;
		messageText.text = "You lost the battle. GAME OVER.";
		if (messageTimer!= null){
			messageTimer.cancel();
			messageTimer = null;
		}
		messageTimer = new FlxTimer(3,goToGameOver,0);
	}

	private function battleWon():Void{
		// trace("battle won");

		if (battleFinished){
			return;
		}

		FlxG.sound.play(Reg.SND_ENEMY_DEAD);

		battleFinished = true;
		wait = true;
		playerTurn = true;
		enemyPortrait.visible = false;
		messageText.text =  "You won!";

		if (messageTimer!= null){
			messageTimer.cancel();
			messageTimer = null;
		}
		messageTimer = new FlxTimer(2,showStatsUpgrade,0);
	}

	private function playerTurnFinished(timer:FlxTimer):Void{
		if (battleFinished)
			return;

		timer.cancel();
		timer = null;

		messageText.text = "";
		wait = true;
	}

	private function enemyTurnFinished(timer:FlxTimer):Void{
		if (battleFinished)
			return;

		timer.cancel();
		timer = null;

		messageText.text = "";
		wait = false;
	}

	private function showStatsUpgrade(timer:FlxTimer):Void{

		p.exp += e.giveExp;

		var iniLevel = p.level;
		//LEVEL UP?

		var i = p.level-1;
		while(i < p.MAXLV){
			if(p.exp >= p.expLV[i] && i > p.level -1){
				// trace("level up");
				p.level = i + 1;
				p.health = p.healthLV[p.level-1];
				p.str = p.strLV[p.level-1];
				p.df = p.dfLV[p.level-1];
				p.spd = p.spdLV[p.level-1];
				p.mp = p.mpLV[p.level-1];
			}
			i++;
		}

		if (iniLevel != p.level){
			messageText.text = "You reached level " + p.level + "!";
		}else{
			messageText.text = "You got " + e.giveExp + " EXP points.";
		}
		
		timer.cancel();
		messageTimer = new FlxTimer(2,closeBattle,0);
	}

	private function closeBattle(timer:FlxTimer):Void{
		// trace("close battle");
		FlxG.sound.pause();
		timer.cancel();
		timer = null;
		state.finishBattle(e);
	}

	private function updatePlayerHUD():Void{
		HPmeter.text = "HP - " + p.health;
		MPmeter.text = "MP - " + p.mp;
	}

	private function hideActionSelector():Void{
		fightText.visible = false;
		defendText.visible = false;
		healText.visible = false;
		techText.visible = false;
		selector.visible = false;
	}

	private function showActionSelector():Void{
		fightText.visible = true;
		defendText.visible = true;
		healText.visible = true;
		techText.visible = true;
		selector.visible = true;
	}
	
	private function executeActionSelected():Void{
		if (selector.x == fightText.x && selector.y == fightText.y){
			//FIGHT
			var i = FlxRandom.intRanged(0,5);
			if (i == 5){
				FlxG.sound.play(Reg.SND_FAIL);
				messageText.text = "Missed!";	
			}else{
				FlxG.sound.play(Reg.SND_FIGHT);
				e.health -= p.str;
				messageText.text = e.name + " received damage of " + p.str;	
				// FlxTween.tween(enemyPortrait, { x:enemyPortrait.x, y:enemyPortrait.y - 15 ,}, 1 ,{ type:FlxTween.ONESHOT, ease:FlxEase.quadInOut, complete:null, startDelay:0, loopDelay:0 });
			}
		}

		if (selector.x == defendText.x && selector.y == defendText.y){
			//DEFEND
			messageText.text = "Your defense went up!";
			playerExtraDF = p.df;
			FlxG.sound.play(Reg.SND_DEFEND);
		}

		if (selector.x == techText.x && selector.y == techText.y){
			//TECH
			if (p.mp >= p.TECH_COST){
				FlxG.sound.play(Reg.SND_TECH);
				messageText.text = "Special attack!, " + e.name + " received " + p.techDMG[p.level-1] + " DMG";
				e.health -= p.techDMG[p.level-1];
				p.mp -= p.TECH_COST;
			}else{
				messageText.text = "Special attack!... not enough MP.";
			}

			if (p.mp < 0){
				p.mp = 0;
			}
		}

		if (selector.x == healText.x && selector.y == healText.y){
			//HEAL
			if (p.mp >= p.HEAL_COST){
				FlxG.sound.play(Reg.SND_HEAL);
				messageText.text = "Heal magic!, recovered " + p.healHP[p.level-1] + "HP";
				p.health += p.healHP[p.level-1];
				if (p.health >= p.healthLV[p.level-1]){
					p.health = p.healthLV[p.level-1];
				}
				p.mp -= p.TECH_COST;
			}else{
				messageText.text = "Heal magic!... not enough MP.";
			}

			if (p.mp < 0){
				p.mp = 0;
			}
		}

		messageTimer = new FlxTimer(1.5,playerTurnFinished,0);

		playerTurn = false;
	}

	private function goToGameOver(timer:FlxTimer):Void{
		timer.cancel();
		timer = null;
		FlxG.sound.pause();
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
    		FlxG.switchState(new GameOverState());
		});
	}

	
}
