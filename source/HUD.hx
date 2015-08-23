package;

 import flixel.FlxBasic;
 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxTypedGroup;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;
 import flixel.ui.FlxBar;
 import flixel.FlxObject;
 using flixel.util.FlxSpriteUtil;

 class HUD extends FlxTypedGroup<FlxSprite>
 {

    private var textLevel:FlxText;  
    private var textTime:FlxText;
    private var textDay:FlxText;
    private var timeBar:FlxBar;
    private var hudX:Float;
    private var hudY:Float;
    private var hudTextColor:Int = FlxColor.WHITE;


     public function new()
     {
        super();

        hudX = FlxG.camera.scroll.x;
        hudY = FlxG.camera.scroll.y;

        textLevel = new FlxText(hudX + 10, hudY + 10,100,"LEVEL");
        textLevel.setFormat(Reg.MAIN_FONT, 30,hudTextColor,"center",1,hudTextColor);
        add(textLevel);

        textDay = new FlxText(hudX + 260,hudY + 10,100,"DAY");
        textDay.setFormat(Reg.MAIN_FONT,30,hudTextColor,"center",1,hudTextColor);
        add(textDay);

        textTime = new FlxText(hudX + 430,hudY + 10,100,"TIME");
        textTime.setFormat(Reg.MAIN_FONT, 30,hudTextColor,"center",1,hudTextColor);
        add(textTime);

        timeBar = new FlxBar(hudX + 520,hudY + 10,FlxObject.LEFT,100,20,null,null,0,100,true);
        timeBar.currentValue = 0;
        add(timeBar);
     }

     public function updateHUD(level:Int = 1, time:Float = 0,day:Int = 1):Void{

        hudX = FlxG.camera.scroll.x;
        hudY = FlxG.camera.scroll.y;


        //updates position
        textLevel.x = hudX + 10;
        textLevel.y = hudY + 10;

        textDay.x = hudX + 260;
        textDay.y = hudY + 10;

        textTime.x = hudX + 430;
        textTime.y = hudY + 10;

        timeBar.x = hudX + 520;
        timeBar.y = hudY + 10;

        //updates text
        textLevel.text = "LEVEL " + level;
        textDay.text = "DAY " + day;

        //updates times
        timeBar.currentValue = time;

     }
 }