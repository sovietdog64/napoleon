//Background shade

switch(invType) {
	case inventories.CRAFTING: {
		
	} break;
	
	default: {
		var multiplier = SLOT_SIZE+5;
		draw_sprite_stretched(
			spr_invPanel,
			0,
			invRect[0].x,
			invRect[0].y,
			invRect[1].x-invRect[0].x,
			invRect[1].y-invRect[0].y
		);
		
		for(var i=0; i<invSize; i++) {
			var p = slotPositions[i];
			draw_sprite(spr_invSlot, 0, p.x, p.y);
			if(isItem(invArray[i]))
				draw_sprite(invArray[i].itemSpr, 0, p.x, p.y);
		}
	} break;
}