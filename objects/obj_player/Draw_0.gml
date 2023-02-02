//Limb segment lengths
var len1 = 20;
var len2 = 30;

var xOrigin = x;
var yOrigin = y-7;
var heldItem = global.hotbarItems[global.equippedItem];
if(!isItem(heldItem)) {
	draw_self();
}
else if(!global.dead && isFirearm(heldItem) && leftAttackCooldown <= 0) {
	sprite_index = spr_playerNoHands;
	var mouseDir = point_direction(xOrigin, yOrigin, mouse_x, mouse_y);
	var dist = 42;
	//Behind arm
	if(mouseDir >= 270 || mouseDir <= 90) {
		image_xscale = 1; 
		var xx = xOrigin+(dist*dcos(mouseDir));
		var yy = (yOrigin)+(-dist*dsin(mouseDir));
		//dist -= 10;
		drawSpiderLimbLeft(xOrigin, yOrigin, xx, yy, len1, len2, c_black, c_black, 3, 1);
		dist -= 30;
		drawSpiderLimbLeft(xOrigin, yOrigin, xx, yy, len1, len2, c_gray, c_gray, 3, 1);
	}	
	else {
		image_xscale = -1;
		dist += 20;
		var xx = xOrigin+(dist*dcos(mouseDir));
		var yy = (yOrigin)+(-dist*dsin(mouseDir));
		drawLimbRight(xOrigin, yOrigin, xx, yy, len1, len2, c_black, c_black, 4, 2);
		drawLimbRight(xOrigin, yOrigin, xx, yy, len1, len2, c_gray, c_gray, 3, 1);
	}
	draw_self();
	//Frint arm
	mouseDir = point_direction(xOrigin, yOrigin, mouse_x, mouse_y);
	if(mouseDir >= 270 || mouseDir <= 90) {
		dist += 20;
		xx = x+(dist*dcos(mouseDir));
		yy = (yOrigin)+(-dist*dsin(mouseDir));
		drawSpiderLimbLeft(xOrigin, yOrigin, xx, yy, len1, len2, c_black, c_black, 4, 2);
		drawSpiderLimbLeft(xOrigin, yOrigin, xx, yy, len1, len2, c_gray, c_gray, 3, 1);
	}	
	else {
		dist -= 20;
		xx = x+(dist*dcos(mouseDir));
		yy = (yOrigin)+(-dist*dsin(mouseDir));
		drawLimbRight(xOrigin, yOrigin, xx, yy, len1, len2, c_black, c_black, 4, 2);
		drawLimbRight(xOrigin, yOrigin, xx, yy, len1, len2, c_gray, c_gray, 3, 1);
	}
	//Drawing held item
	xx = xOrigin+(20*dcos(mouseDir-1));
	yy = yOrigin+(-20*dsin(mouseDir-1));

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