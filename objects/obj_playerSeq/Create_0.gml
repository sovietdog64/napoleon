#region animations

//Vars for limb positions
shoulderB = new Point(x, y)
handB = new Point(x+10, y+10);
shoulderF = new Point(x, y);
handF = new Point(x+10, y+10);
hBOrigin = copyStruct(handB);
hFOrigin = copyStruct(handF);

handProgress = 0;
handDir = 0.3;

footProgress = 0;
footDir = 8;

footRadius = 3;

walkAnimSpd = 5;

//Legs
hipB = new Point(x-10, y-10);
footB = new Point(hipB.x, y+20);
hipF = new Point(x+10, y+10);
footF = new Point(hipF.x, y+20);

legLen = sprite_get_width(spr_playerLegB)*2;
armLen = sprite_get_width(spr_playerArmB)*2;
fBOrigin = new Point(hipB.x, hipB.y+legLen);
fFOrigin = new Point(hipF.x, hipF.y+legLen);

animType = itemAnimations.NONE;

#endregion animations

walkSpd = 0;

animType = itemAnimations.NONE;

item = -1;

targX = 0;
targY = 0;