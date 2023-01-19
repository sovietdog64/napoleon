
function camWidth() {return camera_get_view_width(view_camera[0]);}
function camHeight() {return camera_get_view_height(view_camera[0]);}
function camX() {return camera_get_view_x(view_camera[0]);}
function camY() {return camera_get_view_y(view_camera[0]);}

///@function drawNPCQueryBox
///@param {string} npcName Name of NPC
function drawNPCQueryBox(npcName) {
	draw_set_halign(fa_center);
	draw_set_color(c_green);
	draw_set_font(fnt_npc);
	
	draw_set_alpha(0.7);
	draw_rectangle_color(camWidth()*0.3, camHeight()*0.85, (camWidth()*0.3)+550, (camHeight()*0.85)+100, c_black,c_black,c_black,c_black, false);
	draw_set_alpha(1);
	
	draw_text_transformed(camWidth()/2, 0 + camHeight()-110, "Talk to " + npcName + "?", 3, 3, 0);
	draw_set_color(c_yellow);
	draw_text_transformed(camWidth()/2, 0 + camHeight()-60, "Press <ENTER>", 2, 2, 0);
}

///@function drawNPCMessage
///@param {string} npcName Name of NPC
///@param {string} msg Message to be displayed
///@param {pointer} boxColor Color of the txt box
///@param {pointer} txtColor Color of txt
function drawNPCMessage(npcName, msg, boxColor, txtColor) {
	draw_set_font(fnt_npc);
	draw_rectangle_color(camWidth()*0.3, camHeight()*0.85, (camWidth()*0.3)+550, (camHeight()*0.85)+100, boxColor,boxColor,boxColor,boxColor, false);
	obj_player.inDialogue = true;
	draw_set_color(txtColor);
	draw_text_transformed(camWidth()/2, 0 + camHeight()-110, msg, 1, 1, 0);
	draw_set_color(c_yellow);
	draw_text_transformed(camWidth()*0.2, camHeight()*0.75, "Press <Q> to exit", 2, 2, 0);
	draw_text_transformed((camWidth()*0.3)+550, camHeight()*0.75, "Left click to continue", 2,2,0);
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
	if(index == global.equippedItem && isHotbarSlot) draw_sprite(spr_equippedSlot, 0, xx,yy);
		else draw_sprite(spr_invSlot, 0, xx, yy);
	//If the item in the slot is not null, then draw it.
	if(item != -1) 
		draw_sprite(item, 0, xx, yy);
	if(amount > 1) {
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_text_transformed(xx+110, yy+110, string(amount), 1, 1, 0);
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

///@function doTransition
///@desc Draws transition and goes to next room
function doTransition() {
	if(layer_get_id("TopAnimations") == -1) layer_create(-200, "TopAnimations");
	var inst = instance_create_layer(camX(), camY(), "TopAnimations", obj_animation);
	inst.sprite_index = spr_transition;
	inst.image_xscale *= (inst.sprite_width/camWidth())+1;
	inst.image_yscale *= (inst.sprite_height/camHeight())+1;
}

///@function drawOptions
///@desc Returns the index of the option clicked. Returns undefined if nothing was clicked.
///@param listOfOptions A list containing names of all options to draw.
function drawOptions(listOfOptions) {
	draw_set_font(fnt_npc);
	draw_set_color(c_white);
	if(array_length(listOfOptions) <= 0) return;
	var xx = 800;
	var yy = 50;
	draw_sprite(spr_options, 0, xx, yy);
	var clickedIndex = undefined;
	for(var i=0; i<array_length(listOfOptions); i++) {
		draw_set_halign(fa_center);
		draw_text_transformed(xx+250, yy+25+100*i, listOfOptions[i], 2, 2, 0);
		var tempX = xx+500;
		var tempY = yy+100;
		if(point_in_rectangle(mouse_x, mouse_y, camX()+xx, camY()+yy+100*i, camX()+tempX, camY()+tempY+100*i)) {
			draw_rectangle(xx, yy+100*i, tempX, tempY+100*i, c_white);
			if(mouse_check_button_pressed(mb_left) && clickedIndex == undefined) {
				clickedIndex = i;
			}
		}
	}
	return clickedIndex;
}

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

function drawLimbLeft(xx, yy, targX, targY, segment1Len, segment2Len, color1, color2, width1, width2) {
	var dist = distanceBetweenPoints(xx, yy, targX, targY);
	var dir = point_direction(xx, yy, targX, targY);
	var thighDir = darctan(dist/segment1Len);
	thighDir -= dir;
	thighDir -= thighDir/2.5;
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

function distanceBetweenPoints(x1, y1, x2, y2) {
	var xx = power((x2-x1), 2);
	var yy = power((y2-y1), 2);
	return sqrt(xx+yy);
}

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
		layer_create(-999, "Animations");
	var inst = layer_sequence_create("Animations", xx, yy, sequence);
	return inst;
}