hspWalk = distance_to_point(xprevious, yprevious)
hspWalk = clamp(hspWalk, -10, 10);

if(in_sequence) {
	if(layer_sequence_is_finished(sequence_instance)) {
		var objs = sequence_get_objects(sequence_instance);
		for(var i=0; i<array_length(objs); i++)
			instance_destroy(objs[i])
		layer_sequence_destroy(sequence_instance);
		instance_destroy();
		return;
	}
}


#region animations
shoulderB.x = x+3*image_xscale;
shoulderB.y = y-2;
shoulderF.x = x-3*image_xscale;
shoulderF.y = y-2;


//Handling which animation to do
if(variable_struct_exists(heldItem, "animationType")) {
	animType = heldItem.animationType;
}
else {
	if(isFirearm(heldItem)) {
		variable_struct_set(heldItem, "animationType", itemAnimations.GUN);
		animType = itemAnimations.GUN;
	}
	else
		animType = itemAnimations.NONE;
}
switch(animType) {
	case itemAnimations.NONE:
		doWalkingArmMovements(10, hspWalk/7, 15);
	break;
	case itemAnimations.PUNCHING: {
		//Fists up. Idle.
		if(leftAttackCooldown <= 0) {
			holdFistsUp(mouse_x, mouse_y);
		}
		else {
			doPunchingMovements(mouse_x, mouse_y);
		}
	} break;
	case itemAnimations.KNIFE_STAB: {
		if(leftAttackCooldown <= 0)
			doWalkingArmMovements(10, hspWalk/7, 15);
		else
			doStabMovement(mouse_x, mouse_y);
	}
}
hipB.x = x-5*sign(image_xscale);
hipB.y = y+8;
	
hipF.x = x+2*sign(image_xscale);
hipF.y = y+8;
doWalkingLegMovements(14, 5, hspWalk/7);

//if(isItem(heldItem) && heldItem.itemSpr == spr_boxingGloves)
//	variable_struct_set(heldItem, "animationType", itemAnimations.PUNCHING);
//else if(isItem(heldItem) && heldItem.itemSpr == spr_tanto)
//	variable_struct_set(heldItem, "animationType", itemAnimations.KNIFE_STAB);

#endregion animations
