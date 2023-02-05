var heldItem = global.hotbarItems[global.equippedItem];
if(!isItem(heldItem)) {
	draw_self();
}
else if(!global.dead && isFirearm(heldItem) && heldItem.currentAmmoAmount != 0) {
	sprite_index = spr_playerNoHands;
	drawFirearmRifle(heldItem.itemSpr, spr_playerArmF, spr_playerArmF, x, y, mouse_x, mouse_y);
}
else {
	draw_self();
}

//Draw stamina bar
if(global.stamina < global.maxStamina) {
	var temp = image_xscale;
	if(image_xscale < 0)
		image_xscale *= -1;
	var xx = x-(sprite_width/2)-5;
	var yy = 5+y+sprite_height/2;
	var c = c_black;
	draw_set_color(c);
	draw_rectangle(xx,yy, xx+sprite_width, yy+10, 0);
	c = make_color_rgb(47, 124, 247);
	var percentStamina = global.stamina/global.maxStamina;
	if(percentStamina > 0.2 && percentStamina <= 0.4)
		c = c_yellow;
	if(runCooldown > 0 && keyboard_check(vk_shift))
		c = c_red;
		
	if(percentStamina <= 0.2)
		c = c_red;
	draw_set_color(c);
	draw_rectangle(xx+1,yy+1, (xx+sprite_width * global.stamina/global.maxStamina)-1, yy+10-1, 0);
	
	image_xscale = temp;
}

