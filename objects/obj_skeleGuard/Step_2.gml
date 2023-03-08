//Since paths break x/yprevious in begin step & step event, i need to use end step
#region animations

if(obj_player.x >= x)
	image_xscale = 1;
else
	image_xscale = -1;

{//Setting limb positions
	{//Arms
		shoulderF.x = x-3*image_xscale;
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
		
	{//Legs
		hipF.x = x-3*image_xscale;
		hipF.y = y+7;

		fFOrigin.x = hipF.x;
		fFOrigin.y = hipF.y+10;

		footF.x = fFOrigin.x+2*image_xscale;
		footF.y = fFOrigin.y;

	
		hipB.x = x+2*image_xscale;
		hipB.y = y+7;

		fBOrigin.x = hipB.x+2*image_xscale;
		fBOrigin.y = hipB.y+10;

		footB.x = fBOrigin.x;
		footB.y = fBOrigin.y;
	}
}

{//Animations
	var dirFacing = sign(x - xprevious);
	if(dirFacing == 0)
		dirFacing = sign(image_xscale);
	
	switch(state) {
		case states.ATTACKED: {
			if(atkType == "stab")
				knifeStab(legLen, obj_player.x, obj_player.y, maxAtkCooldown);
			else
				swordSwipe(obj_player.x, obj_player.y, walkAnimSpd)
			armBehindWalk(footRadius, walkAnimSpd);
			legWalk(footRadius, walkAnimSpd, dirFacing)
		} break;
		
		case states.MOVE:
			walkMovements(footRadius, walkAnimSpd, dirFacing);
			atkType = choose("stab", "swipe");
		break;
	}
}

#endregion animations