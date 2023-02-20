if (isPlaceableItem(global.heldItem)) {
	draw_sprite_ext(
		global.heldItem.placedSprite,
		0,
		roundToTile(mouse_x, TILEW/2), roundToTile(mouse_y, TILEW/2),
		1,1,0,placeableColorBlend,1
	)
}

if(selectedObj != -1) {
	draw_set_color(c_black);
	var inst = selectedObj;
	draw_rectangle(
		inst.x, inst.y,
		inst.x+inst.sprite_width, inst.y+inst.sprite_height,
		1
	)
}