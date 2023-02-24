/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();



#region animations

{//Setting limb positions
	shoulderF.x = x-2*image_xscale;
	shoulderF.y = y-2;

	hFOrigin.x = shoulderF.x;
	hFOrigin.y = shoulderF.y+10;

	handF.x = hFOrigin.x+2*image_xscale;
	handF.y = hFOrigin.y;


	shoulderB.x = x+4*image_xscale;
	shoulderB.y = y-2;

	hBOrigin.x = shoulderB.x+2*image_xscale;
	hBOrigin.y = shoulderB.y+10;

	handB.x = hBOrigin.x;
	handB.y = hBOrigin.y;
}

{//Animations
	var dirFacing = sign(x - xprevious);
	if(dirFacing == 0)
		dirFacing = sign(image_xscale);
	if(state == states.ATTACKED && attackCooldown > 0) {
		knifeStab(legLen, obj_player.x, obj_player.y, maxAtkCooldown);
	}
}

#endregion animations