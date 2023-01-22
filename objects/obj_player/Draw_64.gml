///@description inv handling/player GUI
if(instance_exists(obj_game) && global.gamePaused || obj_player.inDialogue) return;
var cx = camera_get_view_x(view_camera[0]);
var cy = camera_get_view_y(view_camera[0]);
if(invOpen) {
	draw_set_alpha(0.5);
	draw_rectangle_color(0, 0, RESOLUTION_W, RESOLUTION_H, c_black,c_black,c_black,c_black, 0);
	draw_set_alpha(1);
	
	//Drawing inv slots & handling slot clicks
	for(var i = 0; i < array_length(global.invItems); i++) {
		var xx = (RESOLUTION_W*0.13)+128*i;
		var yy = RESOLUTION_H*0.2;
		
		var spriteToDraw = -1;
		var itemAmount = 0;
		if(isItem(global.invItems[i])) {
			spriteToDraw = global.invItems[i].itemSpr;
			itemAmount = global.invItems[i].amount;
		}
		
		drawInvSlot(spriteToDraw, xx, yy, i, false, itemAmount);
		//If mouse clicks on an item, drag it.
		//Replaces items with the item currently held by the mouse.
		var mouseInSlot = point_in_rectangle(mouse_x-cx,mouse_y-cy, xx,yy, xx+128,yy+128);
		if(mouseInSlot && mouse_check_button_pressed(mb_left)) {
			if(clickedItem == -1) {
				clickedItem = copyStruct(global.invItems[i]);
				global.invItems[i] = -1;
			} else {
				var temp = copyStruct(global.invItems[i]);
				global.invItems[i] = copyStruct(clickedItem);
				clickedItem = temp;
			}
		} else if(mouseInSlot && keyboard_check_pressed(ord("Q"))) {//Drop item if drop keybind pressed (suddenly stopped working for some reason)
			var inst = instance_create_layer(x+50*image_xscale, y, "Instances", obj_item);
			inst.item = copyStruct(global.invItems[i]);
			global.invItems[i] = -1;
		}
	}
	
	//Drawing hotbar slots when inventory is open & handling slot clicks
	for(var i = 0; i < array_length(global.hotbarItems); i++) {
		var xx = (RESOLUTION_W*0.13)+128*i;
		var yy = RESOLUTION_H*0.5;
		
		var spriteToDraw = -1;
		var itemAmount = 0;
		if(isItem(global.hotbarItems[i])) {
			spriteToDraw = global.hotbarItems[i].itemSpr;
			itemAmount = global.hotbarItems[i].amount;
		}
		
		drawInvSlot(spriteToDraw, xx, yy, i, true, itemAmount);
		//Handling slot clicks
		if(point_in_rectangle(mouse_x-cx,mouse_y-cy, xx,yy, xx+128,yy+128) && mouse_check_button_pressed(mb_left)) {
			if(clickedItem == -1) {//If slot is clicked and mouse is not holding something, make mouse pick up item
				clickedItem = copyStruct(global.hotbarItems[i]);
				global.hotbarItems[i] = -1;
			} else {//If mouse is holding item, swap out slot item with the one held by mouse
				var temp = copyStruct(global.hotbarItems[i]);
				global.hotbarItems[i] = clickedItem;
				clickedItem = temp;
			}
		}
	}
	
	//If an item was clicked outside of a slot, drop the item.
	var invX = (RESOLUTION_W*0.13);
	var invY = RESOLUTION_H*0.2;
	var hotbarX = invX;
	var hotbarY = RESOLUTION_H*0.5;
	if(!point_in_rectangle(mouse_x-cx, mouse_y-cy, invX, invY, invX+128*array_length(global.invItems), invY+128) &&
		!point_in_rectangle(mouse_x-cx, mouse_y-cy, hotbarX, hotbarY, hotbarX+128*array_length(global.hotbarItems), hotbarY+128) &&
		mouse_check_button_pressed(mb_left) && clickedItem != -1) {
			
		var foundValidPosition = false;
		var xPos = x+50*sign(image_xscale);
		var yPos = y;
		while(!foundValidPosition) {
			if(place_free(xPos, yPos)) {
				foundValidPosition = true;
			} else {
				xPos -= 5*sign(image_xscale);
			}
		}
		var inst = instance_create_layer(xPos, yPos, "Instances", obj_item);
		inst.item = copyStruct(clickedItem);
		clickedItem = -1;
	}
}

if(isItem(clickedItem)) {
	draw_sprite(obj_player.clickedItem.itemSpr, 0, mouse_x-(64+camX()), mouse_y-(64+camY()));
}

//Drawing hotbar/items in use when outside of inventory
if(!invOpen && !global.dead) {
	for(var i = 0; i < array_length(global.hotbarItems); i++) {
		var xx = (RESOLUTION_W*0.7)+128*i;
		var yy = RESOLUTION_H*0.05;
		
		var spriteToDraw = -1;
		var itemAmount = 0;
		if(isItem(global.hotbarItems[i])) {
			spriteToDraw = global.hotbarItems[i].itemSpr;
			itemAmount = global.hotbarItems[i].amount;
		}
		
		drawInvSlot(spriteToDraw, xx, yy, i, true, itemAmount);
		draw_set_color(c_white)
		draw_set_font(fnt_npc);
		draw_set_halign(fa_left);
		draw_text_transformed(xx, yy+65, "Key " + string(i+1), 1, 1, 0);
		//If a hotkey for an item in use is pressed, equip it.
		if(keyboard_check_pressed(ord(string(i+1)))) {
			global.equippedItem = i;
		}
	}
}

//Drawing health
for(var i = 0; i < global.hp; i++) {
	draw_sprite(spr_health, 0, (32*i)-5, 70);
}

//Drawing quest
if(array_length(global.activeQuests) > 0) {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	var x1 = RESOLUTION_W*0.8;
	var y1 = RESOLUTION_H*0.2;
	var x2 = RESOLUTION_W;
	var y2 = RESOLUTION_H*0.7;
	draw_rectangle(x1, y1, x2, y2, 0);
	draw_set_alpha(1);
	draw_set_font(fnt_npc);
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	var quest = global.activeQuests[0];
	draw_text_transformed(x1+20, y1+20, quest.questName, 1.5, 1.5, 0);
	draw_text_transformed(x1+20, y1+70, quest.questDesc, 1.5, 1.5, 0);
	var col = c_red;
	if(quest.progress >= 0.3)
		col = c_yellow;
	if(quest.progress >= 0.7)
		col = c_green;
	draw_set_color(col);
	draw_text_transformed(x1+20, y1+120, string(quest.progress*100)+"%", 1.5, 1.5, 0);
	draw_set_alpha(1);
}
	
//Drawing crosshair & amount of ammo 
var heldItem = global.hotbarItems[global.equippedItem];
if(isFirearm(heldItem)) {
	var mouseX = device_mouse_x_to_gui(0);
	var mouseY = device_mouse_y_to_gui(0);
	draw_sprite(spr_crosshair, 0, mouseX, mouseY);
	if(isFirearm(heldItem) && noAmmo(heldItem)) {
		draw_set_color(c_red);
		draw_set_halign(fa_center);
		draw_set_font(fnt_notif);
		draw_text_transformed(x-camX(), (y-camY())-100, "NO AMMO", 2, 2, 0);
		draw_text_transformed(mouseX, mouseY, "NO AMMO", 2, 2, 0);
	}
	else {
		draw_set_halign(fa_center);
		draw_set_color(c_yellow);
		if(heldItem.currentAmmoAmount <= 0)
			draw_set_color(c_red);
		var strToDraw = heldItem.ammoName + ": " + string(heldItem.currentAmmoAmount);
		if(leftAttackCooldown > 0)
			strToDraw = "...";
		
		draw_text_transformed(mouseX, mouseY-80, strToDraw, 1, 1, 0);
	}
}