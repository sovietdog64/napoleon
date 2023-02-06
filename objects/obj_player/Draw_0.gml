draw_self();
if(isItem(global.heldItem)) {
	switch(itemAnimation) {
		case itemAnimations.NONE:{
			
			drawWalkingArms();
		}
		break;
		case itemAnimations.GUN: {
			if(attackState == attackStates.RELOAD)
				break;
			if(isFirearm(global.heldItem))
			switch(global.heldItem.gunType) {
				case gunTypes.RIFLE:
					drawFirearmRifle(global.heldItem.itemSpr, spr_playerArmF, spr_playerArmF, x, y, mouse_x, mouse_y);
				break;
			}
		} break;
		default: show_debug_message("eE") break;
	}
}
else {
	drawWalkingArms()
}