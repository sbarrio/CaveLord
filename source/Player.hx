package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;

class Player extends FlxSprite
{

    private static var PLAYER_SPEED:Float = 4000;
    private static var MAX_PLAYER_SPEED:Float = 8000;

    public var TECH_COST:Int= 5;
    public var HEAL_COST:Int= 5;

    public var expLV : Array<Int> = [0,40,160,310,450,600];
    public var MAXLV = 6;

    public var healthLV : Array<Int> = [15,25,30,35,40,50];
    public var strLV : Array<Int> = [5,12,18,25,30,35];
    public var dfLV : Array<Int> = [5,10,15,20,25,30];
    public var spdLV : Array<Int> = [5,10,20,30,40,50];
    public var mpLV : Array<Int> = [5,10,15,20,25,30];

    public var techDMG : Array<Int> = [8,14,20,28,34,38];
    public var healHP : Array<Int> = [4,6,8,10,12,14,26];

    public var level:Int = 1;
    public var df:Int = 0;
    public var str:Int = 0;
    public var spd:Int = 0;
    public var mp:Int = 0;
    public var exp:Int = 0;

    private var dir:Int = FlxObject.DOWN;

    public function new(X:Float, Y:Float,Level:Int,Health:Float,DF:Int,STR:Int,SPD:Int,MP:Int,EXP:Int,state:MapState)
    {
        super(X,Y);

        loadGraphic(Reg.PLAYER, true, 128, 128, true, "player");
        level = Level;
        health = Health;
        df = DF;
        str = STR;
        spd = SPD;
        mp = MP;
        exp = EXP;

        // setFacingFlip(FlxObject.LEFT, true, false);
        // setFacingFlip(FlxObject.RIGHT, false, false);

        drag.x = PLAYER_SPEED*8;
        drag.y = PLAYER_SPEED*8;
        maxVelocity.set(MAX_PLAYER_SPEED, MAX_PLAYER_SPEED);

        //bounding box
        width = 100;
        height = 80;
        offset.set(10, 48);


        // animations
        animation.add("idle_up", [1], 1, true);
        animation.add("idle_left",[8],1,true);
        animation.add("idle_right",[6],1,true);
        animation.add("idle_down",[0],1,true);

        // animations
        animation.add("walk_up", [4, 5], 8, true);
        animation.add("walk_left",[8,9],8,true);
        animation.add("walk_right",[6,7],8,true);
        animation.add("walk_down",[2,3],8,true);
    }

    override public function update():Void
    {

        this.velocity.x = 0;
        this.velocity.y = 0;
        this.acceleration.x = 0;
        this.acceleration.y = 0;
        
        //INPUT
        if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN)
        {   
            moveLeft();
        }

        if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.UP)
        {   
            moveLeftUp();
        }       

        if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.DOWN)
        {   
            moveLeftDown();
        }     

        if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN)
        {
            moveRight();    
        }

        if (FlxG.keys.pressed.RIGHT && FlxG.keys.pressed.UP)
        {   
            moveRightUp();
        }       

        if (FlxG.keys.pressed.RIGHT && FlxG.keys.pressed.DOWN)
        {   
            moveRightDown();
        }  

        if (FlxG.keys.pressed.UP && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
        {
            moveUp();
        }

        if (FlxG.keys.pressed.DOWN && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
        {
            moveDown();
        }

        //IDLE ANIMATION
        if (acceleration.x == 0 && acceleration.y == 0){
            switch(dir){
                case FlxObject.UP: animation.play("idle_up");
                case FlxObject.DOWN: animation.play("idle_down");
                case FlxObject.RIGHT: animation.play("idle_right");
                case FlxObject.LEFT: animation.play("idle_left");
            }
        }

        super.update();
    }

    private function moveRight():Void{
            facing = FlxObject.RIGHT;
            acceleration.x += drag.x;
            acceleration.y = 0;
            animation.play("walk_right");
            dir = FlxObject.RIGHT;
    }

    private function moveRightUp():Void{
            facing = FlxObject.UP;
            acceleration.x += drag.x;
            acceleration.y -= drag.y;
            animation.play("walk_up");
            dir = FlxObject.UP;
    }

    private function moveRightDown():Void{
            facing = FlxObject.DOWN;
            acceleration.x += drag.x;
            acceleration.y += drag.y;
            animation.play("walk_down");
            dir = FlxObject.DOWN;
    }

    private function moveLeft():Void{
            facing = FlxObject.LEFT;
            acceleration.x -= drag.x;
            acceleration.y = 0;
            animation.play("walk_left");
            dir = FlxObject.LEFT;
    }

    private function moveLeftUp(){
        facing = FlxObject.UP;
        acceleration.x -= drag.x;
        acceleration.y -= drag.y;
        animation.play("walk_up");
        dir = FlxObject.UP;
    }

    private function moveLeftDown(){
            facing = FlxObject.DOWN;
            acceleration.x -= drag.x;
            acceleration.y += drag.y;
            animation.play("walk_down");
            dir = FlxObject.DOWN;
    }

    private function moveUp():Void{
            facing = FlxObject.UP;
            acceleration.x = 0;
            acceleration.y -= drag.y;
            animation.play("walk_up");
            dir = FlxObject.UP;
    }

    private function moveDown():Void{
            facing = FlxObject.DOWN;
            acceleration.x = 0;
            acceleration.y += drag.y;
            animation.play("walk_down");
            dir = FlxObject.DOWN;
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}