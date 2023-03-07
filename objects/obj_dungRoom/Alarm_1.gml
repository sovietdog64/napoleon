#region ground

ground = layer_sprite_create(
	layer_get_id("Ground"),
	x+TILEW, y+TILEW,
	groundSpr
)

layer_sprite_xscale(
	ground,
	(rmWidth-TILEW-TILEW)/sprite_get_width(groundSpr)
)

layer_sprite_yscale(
	ground,
	(rmHeight-TILEW-TILEW)/sprite_get_height(groundSpr)
)

#endregion ground