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
	sprite_set_offset(heldItem.itemSpr, 64, 64);
	xx = xOrigin+(20*dcos(mouseDir-1));
	yy = yOrigin+(-20*dsin(mouseDir-1));

	var yScale = -0.5
	if(mouseDir >= 270 || mouseDir <= 90)
		yScale *= -1;
	draw_sprite_ext(heldItem.itemSpr, 0, xx, yy, 0.5, yScale, mouseDir, c_white, 1);
	sprite_set_offset(heldItem.itemSpr, 0, 0);
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
