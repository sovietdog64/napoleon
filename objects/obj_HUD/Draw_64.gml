///@description inv handling/player GUI
if(!instance_exists(obj_player))
	return;

if(global.gamePaused || obj_player.inDialogue) 
	return;

if(!global.screenOpen) {

	//Drawing hotbar when outside of inventory
	if(!global.screenOpen && !global.dead) {
		for(var i = 0; i < array_length(global.hotbarItems); i++) {
			var xx = (RESOLUTION_W*0.8)+INV_SLOT_SIZE*i;
			var yy = (RESOLUTION_H*0.01)+32;
		
			var spriteToDraw = -1;
			var itemAmount = 0;
			if(isItem(global.hotbarItems[i])) {
				spriteToDraw = global.hotbarItems[i].itemSpr;
				itemAmount = global.hotbarItems[i].amount;
			}
		
			var h = INV_SLOT_SIZE/2;
			drawInvSlot(spriteToDraw, xx-h, yy+h, i, true, itemAmount);
			draw_set_color(c_white);
			draw_set_font(fnt_npc);
			draw_set_halign(fa_left);
			draw_text_transformed(xx-54, yy+INV_SLOT_SIZE, "Key " + string(i+1), 1, 1, 0);
			//If a hotkey for a hotbar slot is pressed, equip it.
			if(keyboard_check_pressed(ord(string(i+1)))) {
				global.equippedItem = i;
			}
		}
	}
		
	//Moneys
	var xx = RESOLUTION_W*0.77
	var yy = (RESOLUTION_H*0.01)+112;
	draw_set_color(c_yellow);
	draw_text_transformed(xx, yy, string(global.gold), 1.5, 1.5, 0)

	//Health, quest, and crosshair/amount of ammo
		draw_healthbar(RESOLUTION_W*0.01, RESOLUTION_H*0.12+30,
					   RESOLUTION_W*0.3, RESOLUTION_H*0.12+50,
					   100*(global.hp/global.maxHp),
					   c_black, c_red, c_green,
					   1,
					   true,
					   true)
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		var p = lineMidpoint(RESOLUTION_W*0.01, RESOLUTION_H*0.12+30,
							 RESOLUTION_W*0.3, RESOLUTION_H*0.12+50);
		draw_text(p.x, p.y, string(global.hp) + "/" + string(global.maxHp) + " HP");
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
