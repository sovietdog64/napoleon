///@description inv handling/player GUI
if(instance_exists(obj_game) && global.gamePaused || obj_player.inDialogue) 
	return;
var cx = camera_get_view_x(view_camera[0]);
var cy = camera_get_view_y(view_camera[0]);
if(invOpen) {
	draw_set_alpha(0.5);
	draw_rectangle_color(0, 0, RESOLUTION_W, RESOLUTION_H, c_black,c_black,c_black,c_black, 0);
	draw_set_alpha(1);
	
	//Drawing panel
	var x1 = (RESOLUTION_W*0.07), y1 = RESOLUTION_H*0.07;
	var yOffset = 128*(array_length(global.invItems) div 8);
	
	draw_sprite_ext(spr_invPanel,0, x1,y1, (x1+1024)/128, (y1+yOffset+400)/128, 0, c_white, 1);
	
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
		xx -= 64;
		yy -= 64;
		var mouseInSlot = point_in_rectangle(mouse_x-cx,mouse_y-cy, xx,yy, xx+128,yy+128);
		if(mouseInSlot && mouse_check_button_pressed(mb_left)) {
			var temp;
			if(!isItem(global.invItems[i]))
				temp = -1;
			else
				temp = copyStruct(global.invItems[i]);
			global.invItems[i] = copyStruct(clickedItem);
			clickedItem = temp;
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
		xx -= 64;
		yy -= 64;
		if(point_in_rectangle(mouse_x-cx,mouse_y-cy, xx,yy, xx+128,yy+128) && mouse_check_button_pressed(mb_left)) {
			//Swap out item with item currently being dragged
			var temp;
			if(!isItem(global.hotbarItems[i]))
				temp = -1;
			else
				temp = copyStruct(global.hotbarItems[i]);
			global.hotbarItems[i] = copyStruct(clickedItem);
			clickedItem = temp;
		}
	}
	
	//If an item was clicked outside of a slot, drop the item.
	var invX = (RESOLUTION_W*0.13) - 64;
	var invY = RESOLUTION_H*0.2 - 64;
	var hotbarX = invX;
	var hotbarY = RESOLUTION_H*0.5 - 64;
	var mouseInSlot = point_in_rectangle(mouse_x-cx, mouse_y-cy, invX, invY, invX+128*array_length(global.invItems), invY+128);
	var mouseInHotbarSlot = point_in_rectangle(mouse_x-cx, mouse_y-cy, hotbarX, hotbarY, hotbarX+128*array_length(global.hotbarItems), hotbarY+128);
	if(!mouseInSlot &&
		!mouseInHotbarSlot &&
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
	draw_sprite(clickedItem.itemSpr, 0, mouse_x-(64+CAMX), mouse_y-(64+CAMY));
}

//Drawing hotbar/items in use when outside of inventory
if(!invOpen && !global.dead) {
	for(var i = 0; i < array_length(global.hotbarItems); i++) {
		var xx = (RESOLUTION_W*0.7)+160*i;
		var yy = (RESOLUTION_H*0.05)+32;
		
		var spriteToDraw = -1;
		var itemAmount = 0;
		if(isItem(global.hotbarItems[i])) {
			spriteToDraw = global.hotbarItems[i].itemSpr;
			itemAmount = global.hotbarItems[i].amount;
		}
		
		drawInvSlot(spriteToDraw, xx-32, yy+32, i, true, itemAmount);
		draw_set_color(c_white)
		draw_set_font(fnt_npc);
		draw_set_halign(fa_left);
		draw_text_transformed(xx-64, yy+64, "Key " + string(i+1), 1, 1, 0);
		//If a hotkey for an item in use is pressed, equip it.
		if(keyboard_check_pressed(ord(string(i+1)))) {
			global.equippedItem = i;
		}
	}
}

//Health, quest, and crosshair/amount of ammo
if(!invOpen) {
	//Drawing health
	for(var i = 0; i < global.hp; i++) {
		draw_sprite(spr_health, 0, (32*i)-5, 70);
	}
	
	//Drawing quest
	if(array_length(global.activeQuests) > 0) {
		var x1 = RESOLUTION_W*0.8;
		var y1 = RESOLUTION_H*0.2;
		var x2 = RESOLUTION_W;
		var y2 = RESOLUTION_H*0.7;
		nineSliceBoxStretched(spr_textBoxes, x1, y1, x2, y2);
		draw_set_font(fnt_npc);
		draw_set_halign(fa_left);
		draw_set_color(c_white);
		var i = 0;
		var quest = global.activeQuests[0];
		draw_text_transformed(x1+20, y1+20, quest.questName, 1.5, 1.5, 0);
		draw_text_transformed(x1+20, y1+70, quest.questDesc, 1.5, 1.5, 0);
		var col = c_red;
		if(quest.progressPercentage >= 0.3)
			col = c_yellow;
		if(quest.progressPercentage >= 0.7)
			col = c_green;
		draw_set_color(col);
		draw_text_transformed(x1+20, y1+120, string(quest.progressPercentage*100)+"%", 1.5, 1.5, 0);
		if(quest.progressPercentage >= 1)
			draw_text_transformed(x1+20, y1+150, "Go to " + quest.questGiver + "\nto get your rewards!", 1.5, 1.5, 0);
		draw_set_alpha(1);
	}
		
	//Drawing crosshair & amount of ammo 
	if(isFirearm(global.heldItem)) {
		var mouseX = device_mouse_x_to_gui(0);
		var mouseY = device_mouse_y_to_gui(0);
		draw_sprite(spr_crosshair, 0, mouseX, mouseY);
		if(isFirearm(global.heldItem) && noAmmo(global.heldItem)) {
			draw_set_color(c_red);
			draw_set_halign(fa_center);
			draw_set_font(fnt_notif);
			draw_text_transformed(x-CAMX, (y-CAMY)-100, "NO AMMO", 2, 2, 0);
			draw_text_transformed(mouseX, mouseY, "NO AMMO", 2, 2, 0);
		}
		else {
			draw_set_halign(fa_center);
			draw_set_color(c_yellow);
			if(global.heldItem.currentAmmoAmount <= 0)
				draw_set_color(c_red);
			var strToDraw = global.heldItem.ammoName + ": " + string(global.heldItem.currentAmmoAmount);
		
			draw_text_transformed(mouseX, mouseY-80, strToDraw, 1, 1, 0);
		}
	}
}