package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	//SPRITES
	public static inline var TITLE:String = "assets/images/title.png";
	public static inline var TITLE_MONSTER:String = "assets/images/titleMonster.png";
	public static inline var PLAYER:String = "assets/images/char/player.png";
	public static inline var ROCKER:String = "assets/images/char/rocker.png";
	public static inline var MAD_CRAB:String = "assets/images/char/mad_crab.png";
	public static inline var VAMPIRE_CAT:String = "assets/images/char/vampire_cat.png";
	public static inline var HERO:String = "assets/images/char/hero.png";

	public static inline var BG_BATTLE:String = "assets/images/bgBattle.png";
	public static inline var SELECTOR:String = "assets/images/selector.png";

	public static inline var GAMEOVER:String = "assets/images/char/gameOver.png";
	public static inline var ENDING:String = "assets/images/char/ending.png";

	//TILE
	public static inline var PATH_TILESHEETS = "assets/images/tile/";

	//SND
	public static inline var SND_START_PRESSED:String = "assets/sounds/startPressed.wav";
	public static inline var SND_SELECTOR_MOVED:String = "assets/sounds/selectorMove.wav";
	public static inline var SND_SELECTOR_BLOCKED:String = "assets/sounds/selectorBlocked.wav";

	public static inline var SND_ENEMY_DEAD:String = "assets/sounds/enemy_dead.wav";
	public static inline var SND_FAIL:String = "assets/sounds/fail.wav";
	public static inline var SND_FIGHT:String = "assets/sounds/fight.wav";
	public static inline var SND_HEAL : String = "assets/sounds/heal.wav";
	public static inline var SND_HURT_PLAYER:String = "assets/sounds/hurt_player.wav";
	public static inline var SND_LEVEL_UP:String = "assets/sounds/level_up.wav";
	public static inline var SND_PLAYER_DEAD:String = "assets/sounds/player_dead.wav";
	public static inline var SND_START_BATTLE:String = "assets/sounds/start_battle.wav";
	public static inline var SND_TECH:String = "assets/sounds/tech.wav";
	public static inline var SND_DEFEND:String = "assets/sounds/defend.wav";

	//MUS
	public static inline var MUS_BATTLE:String = "assets/music/battle.wav";	
	public static inline var MUS_WORLD:String = "assets/music/world.wav";	

	//FONT
	public static inline var MAIN_FONT:String = "assets/font/apple_kid.ttf";
	// public static inline var MAIN_FONT:String = "assets/font/Final-Fantasy.ttf";
}