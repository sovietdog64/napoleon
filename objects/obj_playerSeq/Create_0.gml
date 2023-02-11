//Vars for limb positions
shoulderB = new Point(x, y)
handB = new Point(x, y);
shoulderF = new Point(x, y);
handF = new Point(x, y);

hspWalk = 0;

heldItem = copyStruct(global.heldItem);

handProgress = 0;
handDir = 1;

footProgress = 0;
footDir = 2;

//Legs
hipB = new Point(x-10, y-10);
footB = new Point(hipB.x, y+20);
hipF = new Point(x+10, y+10);
footF = new Point(hipF.x, y+20);

animType = itemAnimations.NONE;