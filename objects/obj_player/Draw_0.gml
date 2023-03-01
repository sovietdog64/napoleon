draw_self();
drawLegs(spr_playerLegB, spr_playerLegF);
drawArms(spr_playerArmB, spr_playerArmF);

var spr = isItem(global.heldItem) ? global.heldItem.itemSpr : 0;

switch(animType) {
	case itemAnimations.KNIFE_STAB: {
		if(!arrayInBounds(leftAttackCooldowns, spr))
			break;
		if(isItem(global.heldItem))
			drawHoldingKnife(
				spr_playerArmB, spr_playerArmF,
				spr,
				leftAttackCooldowns[spr] > 0,
				mouse_x, mouse_y
			)
	}break;
	
	case itemAnimations.SWORD: {
		if(!arrayInBounds(leftAttackCooldowns, spr))
			break;
		if(isItem(global.heldItem))
			drawHoldingSword(
				spr_playerArmB, spr_playerArmF,
				spr,
				leftAttackCooldowns[spr] > 0,
				mouse_x, mouse_y
			)
	}break;
}
	
draw_circle(x, y, 100,1)