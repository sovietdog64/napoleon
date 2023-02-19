if (isPlaceableItem(global.heldItem)) {
	draw_sprite_ext(
		global.heldItem.placedSprite,
		0,
		roundToTile(mouse_x, TILEW/2), roundToTile(mouse_y, TILEW/2),
		1,1,0,placeableColorBlend,1
	)
}