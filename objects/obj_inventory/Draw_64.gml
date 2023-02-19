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

for(var i=0; i<invSize; i++) {
	if(isItem(invArray[i])) {
		var p = slotPositions[i];
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		if(invArray[i].amount > 1)
			draw_text(p.x+slotSize, p.y+slotSize, string(invArray[i].amount));
	}
}