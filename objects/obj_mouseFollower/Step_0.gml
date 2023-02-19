if(!snapToTile) {
	x = mouse_x;
	y = mouse_y;
}
else {
	x = roundToTile(mouse_x, tileSize);
	y = roundToTile(mouse_y, tileSize);
}