if(isItem(global.heldItem)) {
	switch(animType) {
		case itemAnimations.NONE:{
			drawWalkingArms(spr_playerArmB, spr_playerArmF, global.heldItem);
		}
		break;
		case itemAnimations.GUN: {
			if(attackState == attackStates.RELOAD)
				break;
			if(!isFirearm(global.heldItem))
				break;
			switch(global.heldItem.gunType) {
				case gunTypes.RIFLE:
					drawFirearmRifle(global.heldItem.itemSpr, spr_playerArmF, spr_playerArmF, x, y, mouse_x, mouse_y);
				break;
			}
		} break;
		case itemAnimations.PUNCHING: {
			drawFistsUp(spr_playerArmB, spr_playerArmF);
		}
		break;
		case itemAnimations.KNIFE_STAB: {
			drawHoldingKnife(spr_playerArmB, spr_playerArmF, global.heldItem.itemSpr, leftAttackCooldown > 0, mouse_x, mouse_y);
		} break;
	}
}
else {
	drawLegs(spr_playerLegB, spr_playerLegF);
	drawWalkingArms(spr_playerArmB, spr_playerArmF);
}