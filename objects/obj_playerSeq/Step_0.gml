walkSpd = distance_to_point(xprevious, yprevious);

var spr = 0;

if(isItem(item)) {
	animType = item.animationType;
	spr = item.itemSpr;
}
else
	animType = itemAnimations.NONE;
	

	
var inst = instance_nearest(x,y,obj_enemy);
if(distance_to_object(inst) <= TILEW*3) {
	targX = inst.x;
	targY = inst.y;
}

var dirFacing = sign(x - xprevious);
if(dirFacing == 0)
	dirFacing = sign(image_xscale);

switch(animType) {
	case itemAnimations.NONE: 
		walkMovements(footRadius, walkAnimSpd, dirFacing);
	break;
	case itemAnimations.KNIFE_STAB: {
		legWalk(footRadius, walkAnimSpd, dirFacing)
		if(attack) {
			knifeStab(legLen*2, mouse_x, mouse_y, 13);
			armBehindWalk(footRadius, walkAnimSpd, dirFacing);
		} else
			armWalk(footRadius, walkAnimSpd, dirFacing);
	} break;
	
	case itemAnimations.SWORD: {
		legWalk(footRadius, walkAnimSpd, dirFacing)
		if(attack) {
			var factor = 20/item.cooldown;
			factor *= 1.2;
			swordSwipe(targX, targY,(walkAnimSpd/2)*factor*1.1, 90*factor*1.1, image_xscale);
			armBehindWalk(footRadius, walkAnimSpd, dirFacing);
		} else {
			armWalk(footRadius, walkAnimSpd, dirFacing);
		}
	}break;
}