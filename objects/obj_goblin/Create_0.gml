/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
hp = 10;
maxHp = hp;
maxAtkCooldown = room_speed*0.4;
itemDrops = [new Berry(irandom_range(0, 3))]



#region animations
//Vars for limb positions
shoulderB = new Point(0,0)
handB = new Point(0,0);
shoulderF = new Point(0,0)
handF = new Point(0,0)
hBOrigin = copyStruct(handB);
hFOrigin = copyStruct(handF);

handProgress = 0;
handDir = 0.3;

footProgress = 0;
footDir = 8;

footRadius = 2.5;

walkAnimSpd = 8;

//Legs
hipB = new Point(0,0)
footB = new Point(0,0);
hipF = new Point(0,0);
footF = new Point(0,0);

legLen = sprite_get_width(spr_goblinLimbF)*2;
fBOrigin = new Point(0,0);
fFOrigin = new Point(0,0);

animType = itemAnimations.NONE;
#endregion animations