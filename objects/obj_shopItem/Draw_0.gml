draw_self();
if(sprite_exists(item.itemSpr)) {
	sprite_set_offset(item.itemSpr, ITEM_SIZE/2, ITEM_SIZE/2);
	draw_sprite_ext(item.itemSpr, 0, x+sprite_width/2, y+sprite_height/2, 0.4,0.4, 0,c_white,1);
	sprite_set_offset(item.itemSpr, 0,0);
}