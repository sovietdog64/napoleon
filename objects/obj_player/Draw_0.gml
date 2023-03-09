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
	
if(instanceof(global.heldItem) == "Bow") {
	var x1 = x-sprite_width/2;
	var y1 = y-sprite_height;
	draw_healthbar(
		x1, y1, x1+sprite_width, y1+5,
		100*(charge / room_speed), c_black, c_red, c_green, 0, 1, 1
	)
}