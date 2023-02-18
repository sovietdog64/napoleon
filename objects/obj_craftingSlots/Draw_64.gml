//Background shade
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
	draw_sprite_stretched(spr_invSlot, 0, p.x, p.y, slotSize, slotSize);
	if(isItem(invArray[i]))
		draw_sprite_stretched(invArray[i].itemSpr, 0, p.x, p.y, itemSize, itemSize);
}

	
if(is_array(buttons))
	for(var i=0; i<array_length(buttons); i++) {
		var btn = buttons[i];
		if(is_struct(btn))
			btn.draw();
	}