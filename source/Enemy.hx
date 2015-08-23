package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;

class Enemy extends FlxSprite
{

    private static var ENEMY_SPEED:Float = 2000;
    private static var MAX_ENEMY_SPEED:Float = 4000;

    private static var MOVE_TIMER:Float = 50;
    private var lastTimeMoved:Float = 0;

    private var dir:Int;

    //BATTLE STATS
    public var name:String = "Enemy";
    public var df:Int = 5;
    public var str:Int = 5;
    public var spd:Int = 5;
    public var giveExp:Int = 0;

    public function new(X:Float, Y:Float,Level:Int,Name:String,Health:Float,DF:Int,STR:Int,SPD:Int,state:MapState)
    {
        super(X,Y);

        name = Name;
        health = Health;
        df = DF;
        str = STR;
        spd = SPD;

        if (name == "Rocker"){
            loadGraphic(Reg.ROCKER, true, 64, 64, true);    
            giveExp = 10;
        }

        if (name == "Mad Crab"){
            loadGraphic(Reg.MAD_CRAB, true, 64, 64, true);       
            giveExp = 30;
        }

        if (name == "Vampire Cat"){
            loadGraphic(Reg.VAMPIRE_CAT, true, 64, 64, true);       
            giveExp = 50;
        }

        if (name == "Hero"){
            loadGraphic(Reg.HERO, true, 64, 64, true);       
            giveExp = 100;
        }

        // animations
        animation.add("walk_up", [2, 3], 8, true);
        animation.add("walk_left",[6,7],8,true);
        animation.add("walk_right",[4,5],8,true);
        animation.add("walk_down",[0,1],8,true);


        drag.x = ENEMY_SPEED*8;
        drag.y = ENEMY_SPEED*8;
        maxVelocity.set(MAX_ENEMY_SPEED, MAX_ENEMY_SPEED);



        //bounding box
        width = 50;
        height = 50;
        offset.set(9, 14);

        dir = FlxObject.NONE;
    }

    override public function update():Void
    {
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.acceleration.x = 0;
        this.acceleration.y = 0;

        lastTimeMoved--;

        ai();

        switch (dir) {
            case FlxObject.UP: moveUp();
            case FlxObject.DOWN: moveDown();
            case FlxObject.RIGHT: moveRight();
            case FlxObject.LEFT: moveLeft();
        }

        super.update();
    }

    function ai(){
        if (lastTimeMoved <= 0 && name != "Hero"){
            lastTimeMoved = MOVE_TIMER;
            
            var i = FlxRandom.intRanged(0,5);
            switch (i) {
                case 0: dir = FlxObject.UP;
                case 1: dir = FlxObject.LEFT;
                case 2: dir = FlxObject.RIGHT;
                case 3: dir = FlxObject.DOWN;
            }
        }
    }

    private function moveRight():Void{
            facing = FlxObject.RIGHT;
            acceleration.x += drag.x;
            acceleration.y = 0;
            animation.play("walk_right");
    }

    private function moveRightUp():Void{
            facing = FlxObject.UP;
            acceleration.x += drag.x;
            acceleration.y -= drag.y;
            animation.play("walk_up");
    }

    private function moveRightDown():Void{
            facing = FlxObject.DOWN;
            acceleration.x += drag.x;
            acceleration.y += drag.y;
            animation.play("walk_down");
    }

    private function moveLeft():Void{
            facing = FlxObject.LEFT;
            acceleration.x -= drag.x;
            acceleration.y = 0;
            animation.play("walk_left");
    }

    private function moveLeftUp(){
        facing = FlxObject.UP;
        acceleration.x -= drag.x;
        acceleration.y -= drag.y;
        animation.play("walk_up");
    }

    private function moveLeftDown(){
            facing = FlxObject.DOWN;
            acceleration.x -= drag.x;
            acceleration.y += drag.y;
            animation.play("walk_down");
    }

    private function moveUp():Void{
            facing = FlxObject.UP;
            acceleration.x = 0;
            acceleration.y -= drag.y;
            animation.play("walk_up");
    }

    private function moveDown():Void{
            facing = FlxObject.DOWN;
            acceleration.x = 0;
            acceleration.y += drag.y;
            animation.play("walk_down");
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}