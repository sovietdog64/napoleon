guiScreen.drawScreen();

for(var i=0; i<invSize; i++) {
	var p = slotPositions[i];
	draw_sprite(spr_invSlot, 0, p.x, p.y);
}