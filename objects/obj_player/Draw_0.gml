draw_self();
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
		case itemAnimations.PUNCHING:
			drawFistsUp(spr_playerArmB, spr_playerArmF);
		break;
		default: show_debug_message("unidentified animation") break;
	}
}
else {
	drawWalkingArms(spr_playerArmB, spr_playerArmF);
}