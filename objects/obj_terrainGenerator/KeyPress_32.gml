var map = diamondSquare(10);
var lay = layer_get_id("Ground");
for(var xx=0; xx<ds_grid_width(map); xx++) {
	var str = ""
	for(var yy=0; yy<ds_grid_width(map); yy++) {
		var val = ds_grid_get(map, yy, xx);
		ds_grid_set(map, yy, xx, abs(numRound(val)))
		str += " "+string(ds_grid_get(map, yy, xx))
		switch(ds_grid_get(map, yy, xx)) {
			case 0:
				layer_sprite_create(lay, xx*64, yy*64, spr_grass)
			break;
			case 1:
				layer_sprite_create(lay, xx*64, yy*64, spr_grass2)
			break;
			case 2:
				layer_sprite_create(lay, xx*64, yy*64, spr_grass3)
			break;
			case 3:
				layer_sprite_create(lay, xx*64, yy*64, spr_grass4)
			break;
			case 4:
				layer_sprite_create(lay, xx*64, yy*64, spr_grass5)
			break;
			case 5:
				layer_sprite_create(lay, xx*64, yy*64, spr_water)
			break;
			case 6: {
				var spr = layer_sprite_create(lay, xx*64, yy*64, spr_grass)
				layer_sprite_blend(spr, c_yellow)
			} break;
			case 7: {
				var spr = layer_sprite_create(lay, xx*64, yy*64, spr_grass)
				layer_sprite_blend(spr, make_color_rgb(133, 95, 27))
			} break;
		}
	}
	show_debug_message(str);
}