
function camX() {return camera_get_view_x(view_camera[0]);}
function camY() {return camera_get_view_y(view_camera[0]);}

{//LIMBS
	///@function drawLimbRight
	//@param xx hip/shoulder x
	//@param yy hip/shoulder y
	//@param segment1Len length of first segment of limb (Ex Bicep/thigh)
	//@param segment2Len lenght of second segment of limb (Ex forearm/calf)
	//@param color1 color of 1st segment
	//@param color2 color of 2nd segment
	//@param width1 width of 1st segment
	//@param width2 width of 2nd segment
	function drawLimbRight(xx, yy, targX, targY, segment1Len, segment2Len, color1, color2, width1, width2) {
		var dist = distanceBetweenPoints(xx, yy, targX, targY);
		var dir = point_direction(xx, yy, targX, targY);
		var thighDir = darctan(dist/segment1Len);
		thighDir -= dir;
		draw_set_color(color1);
		var jointX = xx+(segment1Len*dsin(thighDir));
		var jointY = yy+(-segment1Len*dcos(thighDir));
		draw_line_width(xx, yy, jointX, jointY, width1);
		var sine = dsin(point_direction(jointX, jointY, targX, targY));
		var cosine = dcos(point_direction(jointX ,jointY, targX, targY));
		var footX = jointX+(segment2Len*cosine);
		var footY = jointY+(-segment2Len*sine);
		draw_set_color(color2)
		draw_line_width(jointX, jointY, footX, footY, width2);
	}

	///@function drawSpiderLimbLeft
	//@param xx hip/shoulder x
	//@param yy hip/shoulder y
	//@param segment1Len length of first segment of limb (Ex Bicep/thigh)
	//@param segment2Len lenght of second segment of limb (Ex forearm/calf)
	//@param color1 color of 1st segment
	//@param color2 color of 2nd segment
	//@param width1 width of 1st segment
	//@param width2 width of 2nd segment
	function drawSpiderLimbLeft(xx, yy, targX, targY, segment1Len, segment2Len, color1, color2, width1, width2) {
		var dist = distanceBetweenPoints(xx, yy, targX, targY);
		var dir = point_direction(xx, yy, targX, targY);

		//Left leg
		var thighDir = -darctan(dist/segment1Len);
		thighDir -= dir;
		thighDir += 180;
		var jointX = x+(segment1Len*dsin(thighDir));
		var jointY = y+(-segment1Len*dcos(thighDir));
		draw_set_color(color1)
		draw_line_width(xx, yy, jointX, jointY, width1);
		var sine = dsin(point_direction(jointX, jointY, targX, targY));
		var cosine = dcos(point_direction(jointX ,jointY, targX, targY));
		var footX = jointX+(segment2Len*cosine);
		var footY = jointY+(-segment2Len*sine);	
		draw_set_color(color2)
		draw_line_width(jointX, jointY, footX, footY, width2)
	}
}

{//USER INTERFACE
	function drawPopup(xx, yy, title, image, caption, options) {
		draw_sprite(spr_popup, 0, xx, yy);
		draw_set_halign(fa_center);
		draw_set_color(c_black);
		draw_set_font(fnt_npc);
		draw_text_transformed(xx, yy-300, title, 4, 4, 0);
		draw_sprite_stretched(image, 0, xx-128, yy-200, 256, 256);
		draw_text_transformed(xx, yy+50, caption, 3, 3, 0);
		var mouseX = device_mouse_x_to_gui(0);
		var mouseY = device_mouse_y_to_gui(0);
		var mouseClicked = mouse_check_button_pressed(mb_left);
		switch(options) {
			case "yes/no":
				//Yes btn
				draw_set_color(c_green);
				draw_text_transformed(xx-264, 640, "YES", 3, 3, 0);
				if(pointInRectangle(mouseX, mouseY, 465, 640, 371, 683)) {
					draw_circle(mouseX, mouseY, 5, 0);
					draw_set_color(c_black)
					draw_circle(mouseX, mouseY, 6, 1);
					if(mouseClicked) 
						return 1;
				}
				//No btn
				draw_set_color(c_red);
				draw_text_transformed(xx+284, 640, "NO", 3, 3, 0);
				if(pointInRectangle(mouseX, mouseY, 932, 643, 1001, 680)) {
					draw_circle(mouseX, mouseY, 5, 0);
					draw_set_color(c_black)
					draw_circle(mouseX, mouseY, 6, 1);
					if(mouseClicked) 
						return 0;
				}
			break;
		
			case "ok":
				//TODO: make OK btn
				draw_text_transformed(xx, yy+640, "OK",  3, 3, 0);
			break;
		}
		return undefined;
	}
	///@function drawNPCQueryBox
	///@param {string} npcName Name of NPC
	function drawNPCQueryBox(npcName) {
		draw_set_halign(fa_center);
		draw_set_color(c_green);
		draw_set_font(fnt_npc);
	
		draw_set_alpha(0.7);
		draw_rectangle_color(RESOLUTION_W*0.3, RESOLUTION_H*0.85, (RESOLUTION_W*0.3)+550, (RESOLUTION_H*0.85)+100, c_black,c_black,c_black,c_black, false);
		draw_set_alpha(1);
	
		draw_text_transformed(RESOLUTION_W/2, 0 + RESOLUTION_H-110, "Talk to " + npcName + "?", 3, 3, 0);
		draw_set_color(c_yellow);
		draw_text_transformed(RESOLUTION_W/2, 0 + RESOLUTION_H-60, "Press <ENTER>", 2, 2, 0);
	}

	///@function drawInvSlot
	///@desc This function draws an inventory slot.
	///@desc If the inputted sprite has a value of "1," it is considered null and wont draw.
	///@param item Sprite of item
	///@param xx X position of where to draw the slot
	///@param yy Y position of where to draw the slot
	///@param index The index of the slot.
	///@param isHotbarSlot State if the slot should be rendered as a hotbar slot (Places border around used hotbar slots).
	function drawInvSlot(item, xx, yy, index, isHotbarSlot, amount) {
		var scl = 1;
		if(!obj_player.invOpen)
			scl = 0.5;
		if(index == global.equippedItem && isHotbarSlot) 
			draw_sprite_ext(spr_equippedSlot, 0, xx,yy, scl, scl, 0, c_white, 1);
		else 
			draw_sprite_ext(spr_invSlot, 0, xx, yy, scl, scl, 0, c_white, 1);
		//If the item in the slot is not null, then draw it.
		if(item != -1) 
			draw_sprite_ext(item, 0, xx, yy, scl, scl, 0, c_white, 1);
		if(amount > 1) {
			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_text_transformed(xx+110*scl, yy+110*scl, string(amount), 1, 1, 0);
		}
	}

	///@function drawNotification
	///@desc Draw custom notification on screen (not pop-up)
	///@param xx X position 
	///@param yy Y position 
	///@param stringToDraw 
	///@param color Text color
	///@param duration Notif duration in frames
	///@param size Text size
	///@param alignment Text alignment (Ex. fa_center)
	///@param angle Angle of text
	function drawNotification(xx, yy, stringToDraw, color, duration, size, alignment, angle) {
		var inst = instance_create_layer(xx, yy, "Notifications", obj_notification);
		inst.stringToDraw = stringToDraw;
		inst.textColor = color;
		inst.duration = duration;
		inst.size = size;
		inst.alignment = alignment;
		inst.angle = angle;
	}
	
	//@param msg Message to draw
	//@param responseArray Array of responses that the player can choose
	//@param [background] optional background index (frame of spr_textBox)
	//Adds a text box to the queue of textboxes 
	function newTextBox(msg, responseArray = [-1], background = 0){
		var obj;
		if(instance_exists(obj_text))
			obj = obj_textQueued;
		else
			obj = obj_text;
		
		//Making textbox/queued textbox
		with(instance_create_layer(0,0, "Instances", obj)) {
			textMsg = msg;
			frame = background;
			responses = responseArray
			//trim markers from responses
			for(var i=0; i<array_length(responses); i++) {
				if(responses[i] == -1)
					continue
				var markerPos = string_pos(":", responses[i]);
				responseScripts[i] = string_copy(responses[i], 1, markerPos-1);
				responseScripts[i] = real(responseScripts[i]);
				responses[i] = string_delete(responses[i], 1, markerPos);
			}
			//if no response array was inputted, set responseScripts to [-1]
			if(responses == [-1]) {
				responseScripts = [-1];
			}
			if(instance_exists(other))
				originInstance = other.id;
			else
				originInstance = noone;
		}
	
		with(obj_player) {
			if(state != PlayerStateLocked){
				lastState = state;
				state = PlayerStateLocked;
			}
		}
	}
}

function distanceBetweenPoints(x1, y1, x2, y2) {
	var xx = power((x2-x1), 2);
	var yy = power((y2-y1), 2);
	return sqrt(xx+yy);
}

///@function pointInRectangle
//Literally a better version of point_in_rectangle, because gamemaker sucks sometimes
function pointInRectangle(px, py, x1, y1, x2, y2) {
	if(px >= min(x1,x2) && px <= max(x1,x2))
		if(py >= min(y1,y2) && py <= max(y1,y2))
			return 1;
	return 0;
}

//@function placeSequenceAnimation
//Returns sequence instance
function placeSequenceAnimation(xx, yy, sequence) {
	if(!layer_exists("Animations"))
		layer_create(-9999, "Animations");
	
	return layer_sequence_create("Animations", xx, yy, sequence);
}
	

function nineSliceBoxStretched(sprite, x1, y1, x2, y2, frame = 0) {
	var size = sprite_get_width(sprite) / 3;
	var w = x2-x1;
	var h = y2-y1;
	
	//Middle
	draw_sprite_part_ext(sprite, frame, size, size, 1, 1, x1+size, y1+size, w-(size*2), h-(size*2), c_white, 1);
	
	{//Corners
		//top left
		draw_sprite_part(sprite, frame, 0, 0, size, size, x1, y1);
		//top right
		draw_sprite_part(sprite, frame, size*2, 0, size, size, x1+w-size, y1);
		//bottom left
		draw_sprite_part(sprite, frame, 0, size*2, size, size, x1, y1+h-size);
		//bottom right
		draw_sprite_part(sprite, frame, size*2, size*2, size, size, x1+w-size, y1+h-size)
	}
		
	{//Edges
		//left edge
		draw_sprite_part_ext(sprite, frame, 0, size, size, 1, x1, y1+size, 1, h-(size*2), c_white, 1);
		//right edge
		draw_sprite_part_ext(sprite, frame, size*2, size, size, 1, x1+w-size, y1+size, 1, h-(size*2), c_white, 1);
		//top edge
		draw_sprite_part_ext(sprite, frame, size, 0, 1, size, x1+size, y1, w-(size*2), 1, c_white, 1);
		//bottom edge
		draw_sprite_part_ext(sprite, frame, size, size*2, 1, size, x1+size, y1+h-size, w-(size*2), 1, c_white, 1);
	}
}