package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxRect;

class MapState extends FlxState
{

	private var level:TiledStage;
	private var levelName = "test";
	public var player:Player;

	private var oldPlayer:Player;

	public var enemies:FlxTypedGroup<Enemy>;

	private var cam: FlxCamera;

	private var isRunning:Bool = true;

	private var time:Float = 100;
	private var day:Int = 1;
	private var timeSpeed = 0.05;
	private var switchingState = false;

	//HUD
	private var hud:HUD;

	//BATTLE
	public var inBattle:Bool = false;
 	private var battleHUD:BattleHUD;

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF000000;

        //loads level
        switch(day){
        	case 1: level = new TiledStage("assets/map/day_1.tmx");
        	case 2: level = new TiledStage("assets/map/day_2.tmx");
        	case 3: level = new TiledStage("assets/map/day_3.tmx");
        	case 4: level = new TiledStage("assets/map/day_4.tmx");
        }

        //adds level tiles
        add(level.backgroundTiles);
        add(level.wallTiles);

        //loads level Objects
        level.loadObjects(this);

        //configures player
        if (oldPlayer != null){
        	player.level = oldPlayer.level;
        	player.health = oldPlayer.health;
        	player.str = oldPlayer.str;
        	player.mp = oldPlayer.mp;
        	player.spd = oldPlayer.spd;
        	player.df = oldPlayer.df;
        	player.exp = oldPlayer.exp;
        }

        //camera leads player movement
        cam = FlxG.camera;
        cam.follow(player,FlxCamera.STYLE_TOPDOWN_TIGHT, null, 0);

        FlxG.camera.fade(FlxColor.BLACK, .33, true);        

        add(level.foregroundTiles);

        //HUD
        hud = new HUD();
        add(hud);
        hud.updateHUD(player.level,time,day);

		FlxG.sound.playMusic(Reg.MUS_WORLD,1,true);

        FlxG.debugger.visible = false;
	}

	//State config
	public function MapStateConfig (?paramPlayer:Player,?paramDay:Int,?paramTimeSpeed:Float):Void{
		//configure player as param passed
        if (paramPlayer != null){
        	oldPlayer = paramPlayer;
        }

        if (paramDay != null){
        	day = paramDay;
        }

        if (paramTimeSpeed != null){
        	timeSpeed = paramTimeSpeed;
        }
	}
	
	override public function update():Void
	{

		if (!isRunning)
			return;

		if (!inBattle){
			super.update();

			//time
			time -= timeSpeed;
			if (!switchingState && time <= 0){
				switchingState = true;
				goToNewDay();
			}

			hud.updateHUD(player.level,time,day);

			//COLLISIONS
			level.collideWithLevel(player); 

			for (e in enemies){
				level.collideWithLevel(e);
			}

			//Player with enemies
			FlxG.overlap(enemies, player, null, overlapped);
		}else{
			//BATTLE LOGIC
			if (!battleHUD.visible){
				battleHUD.visible = true;
			}

			battleHUD.update();
		}
	}	


	private function overlapped(Sprite1:FlxObject, Sprite2:FlxObject):Bool{

        var sprite1ClassName:String = Type.getClassName(Type.getClass(Sprite1));
        var sprite2ClassName:String = Type.getClassName(Type.getClass(Sprite2));

        //Player and Enemy
        if ((sprite1ClassName == "Enemy") && (sprite2ClassName == "Player")){

         	var e: Dynamic = cast(Sprite1,Enemy);
           	var p: Dynamic = cast(Sprite2,Player);

            FlxObject.separateY(Sprite1,Sprite2);
            if (Sprite1.velocity.x > 0){
                //enemy going right
                Sprite2.velocity.x += 100;
            }else{
                //enemy going left
                Sprite2.velocity.x -= 100;
            }

            if (!inBattle){
            	startBattle(e,p);	
            }

            return true;
        }

        return false;
	}


	private function startBattle(enemy:Enemy,player:Player):Void{
		cam.flash(FlxColor.WHITE,2);
		inBattle = true;

		FlxG.sound.pause();

		//stops enemies and player
		for(e in enemies){
			e.active = false;
		}

		FlxG.sound.play(Reg.SND_START_BATTLE);

		player.active = false;

        battleHUD = new BattleHUD(this);
 		add(battleHUD);
 		battleHUD.initBattle(player,enemy);
	}

	public function finishBattle(defeatedEnemy:Enemy):Void{

		var name = defeatedEnemy.name;

		FlxG.sound.playMusic(Reg.MUS_WORLD,1,true);

		enemies.remove(defeatedEnemy);

		//resets enemies and player
		for(e in enemies){
			e.active = true;
		}

		player.active = true;
		battleHUD.destroy();
		battleHUD = null;
		inBattle = false;


		if (name == "Hero"){
			goToEnding();
		}
	}

	private function goToNewDay():Void{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
			var state = new MapState();
			if (day +1 == 4){
				timeSpeed = 0;
			}
			state.MapStateConfig(player,day+1,timeSpeed);
    		FlxG.switchState(state);
		});
	}

	private function goToGameOver():Void{
		FlxG.sound.pause();
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
    		FlxG.switchState(new GameOverState());
		});
	}

	private function goToEnding():Void{
		FlxG.sound.pause();
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
    		FlxG.switchState(new EndingState());
		});
	}

	override public function destroy():Void
	{
		super.destroy();
	}
}