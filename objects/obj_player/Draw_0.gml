//Limb segment lengths
var len1 = 20;
var len2 = 30;

var xOrigin = x;
var yOrigin = y-3;
var heldItem = global.hotbarItems[global.equippedItem];
if(!isItem(heldItem)) {
	draw_self();
}
else if(!global.dead && isFirearm(heldItem) && leftAttackCooldown <= 0) {
	sprite_index = spr_playerNoHands;
	var mouseDir = point_direction(xOrigin, yOrigin, mouse_x, mouse_y);
	var dist = 32;
	//Facing right
	if(mouse_x >= x) {
		image_xscale = abs(image_xscale);
		var xx = xOrigin+(dist*dcos(mouseDir-10));
		var yy = yOrigin+(-dist*dsin(mouseDir-10));
		drawLimbLeftSpr(spr_playerArmB, spr_playerArmB, x, y, xx, yy);
		draw_self();
		xx = (xOrigin)+lengthdir_x(dist, mouseDir);
		yy = yOrigin+lengthdir_y(dist, mouseDir);
		drawLimbLeftSpr(spr_playerArmF, spr_playerArmF, x, y, xx, yy);
	}
	//Facing left
	else {
		image_xscale = -abs(image_xscale);
		var xx = xOrigin+lengthdir_x(dist, mouseDir+5);
		var yy = yOrigin+lengthdir_y(dist, mouseDir+5);
		drawLimbRightSpr(spr_playerArmB, spr_playerArmB, x, y, xx, yy);
		draw_self();
		xx = (xOrigin)+lengthdir_x(dist, mouseDir);
		yy = yOrigin+lengthdir_y(dist, mouseDir);
		drawLimbRightSpr(spr_playerArmF, spr_playerArmF, x, y, xx, yy);
	}
	//Drawing held item
	xx = xOrigin+lengthdir_x(20, mouseDir-1);
	yy = yOrigin+lengthdir_y(20, mouseDir-1);

	var yScale = -0.5
	if(mouseDir >= 270 || mouseDir <= 90)
		yScale *= -1;
	draw_sprite_ext(heldItem.itemSpr, 0, xx, yy, 0.5, yScale, mouseDir, c_white, 1);
}
else if(!global.dead && heldItem.itemSpr == spr_musket) {
	draw_self();
}
else if(heldItem.itemSpr != spr_boxingGloves){
	sprite_index = spr_player;
	draw_self();
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
