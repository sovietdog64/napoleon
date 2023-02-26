draw_self();
drawLegs(spr_playerLegB, spr_playerLegF);
drawArms(spr_playerArmB, spr_playerArmF);

switch(animType) {
	case itemAnimations.KNIFE_STAB: {
		if(isItem(global.heldItem))
			drawHoldingKnife(
				spr_playerArmB, spr_playerArmF,
				global.heldItem.itemSpr,
				leftAttackCooldown > 0,
				mouse_x, mouse_y
			)
	}break;
	
	case itemAnimations.SWORD: {
		if(isItem(global.heldItem))
			drawHoldingSword(
				spr_playerArmB, spr_playerArmF,
				global.heldItem.itemSpr,
				leftAttackCooldown > 0,
				mouse_x, mouse_y
			)
	}break;
}