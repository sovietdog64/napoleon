
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
		var jointX = xx+(segment1Len*dsin(thighDir));
		var jointY = yy+(-segment1Len*dcos(thighDir));
		draw_set_color(color1)
		draw_line_width(xx, yy, jointX, jointY, width1);
		var sine = dsin(point_direction(jointX, jointY, targX, targY));
		var cosine = dcos(point_direction(jointX ,jointY, targX, targY));
		var footX = jointX+(segment2Len*cosine);
		var footY = jointY+(-segment2Len*sine);	
		draw_set_color(color2)
		draw_line_width(jointX, jointY, footX, footY, width2)
	}
	
	function drawLimbRightSpr(segment1Spr, segment2Spr, xx, yy, targX, targY) {
		var segment1Len = sprite_get_width(segment1Spr);
		var dist = distanceBetweenPoints(xx, yy, targX, targY);
		var dir = point_direction(xx, yy, targX, targY);
		var thighDir = darctan(dist/segment1Len);
		thighDir -= dir;
		var jointX = xx+(segment1Len*dsin(thighDir));
		var jointY = yy+(-segment1Len*dcos(thighDir));
		draw_sprite_ext(segment1Spr, 0, xx, yy, 1, 1, point_direction(xx, yy, jointX, jointY), c_white, 1);
		
		var dir = point_direction(jointX, jointY, targX, targY);
		draw_sprite_ext(segment2Spr, 0, jointX, jointY, 1, 1, dir, c_white, 1);
		return new Point(jointX, jointY);
	}
	
	function drawLimbLeftSpr(segment1Spr, segment2Spr, xx, yy, targX, targY) {
		var segment1Len = sprite_get_width(segment1Spr);
		var dist = distanceBetweenPoints(xx, yy, targX, targY);
		var dir = point_direction(xx, yy, targX, targY);

		//Left leg
		var thighDir = -darctan(dist/segment1Len);
		thighDir -= dir;
		thighDir += 180;
		var jointX = xx+(segment1Len*dsin(thighDir));
		var jointY = yy+(-segment1Len*dcos(thighDir));
		draw_sprite_ext(segment1Spr, 0, xx, yy, 1, 1, point_direction(xx, yy, jointX, jointY), c_white, 1);
		var dir = point_direction(jointX, jointY, targX, targY);
		draw_sprite_ext(segment2Spr, 0, jointX, jointY, 1, 1, dir, c_white, 1);
		return new Point(jointX, jointY);
	}
	
	{//Animations
		function doStabMovement(targX, targY) {
			//Progressing through "animation frames"
			handDir = 3 * sign(handDir) * (sprite_width/64);
			handProgress += handDir;
			var maxLen = 30 * (sprite_width/64);
			if(abs(handProgress) > maxLen || handProgress <= 0) {
				handDir *= -1;
				if(handProgress <= 0)
					handProgress = 1;
			}
			//another log graph for stabby movement, except its only one hand
			var stretchDist = 30*log10(handProgress);
			var dir = point_direction(x, y, targX, targY);
			handF.x = x+lengthdir_x(stretchDist, dir);
			handF.y = y+lengthdir_y(stretchDist, dir);
			var stretchDist2 = abs(sprite_width)*0.2;
			var dir2 = point_direction(x, y, targX, targY);
			handB.x = x+lengthdir_x(stretchDist2, dir2);
			handB.y = y+lengthdir_y(stretchDist2, dir2);
		}
			
		function drawArms(armBehindSpr, armFrontSpr) {
			if(image_xscale > 0) {
				drawLimbLeftSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
				draw_self();
				drawLimbLeftSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
			}
			else {
				drawLimbRightSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
				draw_self();
				drawLimbRightSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
			}
		}
		
		function drawLegs(legBehindSpr, legFrontSpr) {
			if(image_xscale > 0) {
				drawLimbRightSpr(legBehindSpr, legBehindSpr, hipB.x, hipB.y, footB.x, footB.y);
				drawLimbRightSpr(legBehindSpr, legBehindSpr, hipF.x, hipF.y, footF.x, footF.y);
				draw_self();
			}
			else {
				drawLimbLeftSpr(legBehindSpr, legBehindSpr, hipB.x, hipB.y, footB.x, footB.y);
				drawLimbLeftSpr(legBehindSpr, legBehindSpr, hipF.x, hipF.y, footF.x, footF.y);
				draw_self();
			}
		}
		
		function doWalkingLegMovements() {
			var factor = abs(sprite_width/64);
			footDir = abs(footDir) * sign(image_xscale);
			footDir = (hspWalk/3) * sign(footDir) * 0.08;
			bOrigin = new Point(hipB.x, hipB.y+25*factor);
			fOrigin = new Point(hipF.x, hipF.y+25*factor);
			var changeInPos = abs(x - xprevious) + abs(y - yprevious);
			if(changeInPos > 0) {
				footProgress += footDir;
				if(abs(footProgress) >= 2*pi) {
					footProgress = 0;
				}
				footB.x = bOrigin.x;
				footB.y = bOrigin.y;
				footF.x = fOrigin.x;
				footF.y = fOrigin.y;
				var radius = 8 * factor
				footB.x += radius*cos(footProgress);
				footB.y += radius*sin(footProgress);
			
				footF.x += radius*cos(footProgress-pi);
				footF.y += radius*sin(footProgress-pi);
			}
			else {
				var bDist= distanceBetweenPoints(footB.x, footB.y, bOrigin.x, bOrigin.y)/2;
				var bDir = point_direction(footB.x, footB.y, bOrigin.x, bOrigin.y)
				footB.x += lengthdir_x(bDist, bDir);
				footB.y += lengthdir_y(bDist, bDir);
				
				var fDist= distanceBetweenPoints(footF.x, footF.y, fOrigin.x, fOrigin.y)/10;
				var fDir = point_direction(footF.x, footF.y, fOrigin.x, fOrigin.y)
				footF.x += lengthdir_x(fDist, fDir);
				footF.y += lengthdir_y(fDist, fDir);
			}
		}
		
		function drawHoldingKnife(armBehindSpr, armFrontSpr, knifeSpr, stabbingBool, targX, targY) {
			drawArms(armBehindSpr, armFrontSpr);
			//Drawing knife
			var xScale = 0.2 * sign(image_xscale);
			var dir;
			if(stabbingBool) {
				dir = point_direction(x, y, targX, targY);
				draw_sprite_ext(knifeSpr, 0, handF.x, handF.y, 0.2, 0.2, dir, c_white, 1);
			}
			else {
				dir = 0;
				draw_sprite_ext(knifeSpr, 0, handF.x, handF.y, xScale, 0.2, dir, c_white, 1);
			}
		}
		
		function doWalkingArmMovements() {
			//Scale animation speed with walk speed
			handDir = hspWalk / 5 * sign(handDir);
			//Do animation of moving
			if(abs(x - xprevious) > 0 || abs(y - yprevious) > 0) {
				handProgress += handDir;
				if(abs(handProgress) >= 17) {
					handDir *= -1;
				}
			}
			//Return to default arm positions smoothly if not moving.
			else {
				handProgress += sign(-handProgress)
			}
			handProgress = clamp(handProgress, -20, 20);
;			//Calculating movements with parabola equation (i finally found a use for math i learned at school)
			var offset = (abs(sprite_width)/3);
			handB.x = shoulderB.x+handProgress+offset*image_xscale;
			handB.y = shoulderB.y+((-0.01*power(handProgress, 2))+offset);
			
			handF.x = shoulderF.x+(-handProgress)+2*image_xscale;
			handF.y = shoulderF.y+((-0.01*power(-handProgress, 2))+offset);
		}
	
		function drawWalkingArms(armBehindSpr, armFrontSpr, itemToDraw = -1) {
			drawArms(armBehindSpr, armFrontSpr);
			var xScale = 0.2 * sign(image_xscale);
			if(isItem(itemToDraw)) 
				draw_sprite_ext(itemToDraw.itemSpr, 0, handF.x, handF.y, xScale, 0.2, 0, c_white, 1);
			else if(is_numeric(itemToDraw) && itemToDraw != -1) {
				try{draw_sprite_ext(itemToDraw, 0, handF.x, handF.y, 0.2, 0.2, 0, c_white, 1);}
					catch(err) {}
			}
		}
	
		function holdFistsUp(targX, targY) {
			if(variable_instance_exists(id, "punchingArm"))
				punchingArm = -1;
			handProgress = 1;
			var stretchDist = abs(sprite_width)*0.3;
			var dir = point_direction(x, y, targX, targY);
			handB.x = x+lengthdir_x(stretchDist, dir);
			handB.y = y+lengthdir_y(stretchDist, dir);
			handF.x = x+lengthdir_x(stretchDist-10, dir);
			handF.y = y+lengthdir_y(stretchDist-10, dir);
			var dirFacing = sign(mouse_x-x);
			if(dirFacing == 0)
				dirFacing = 1;
			image_xscale = abs(image_xscale) * dirFacing;
		}
		
		function doPunchingMovements(targX, targY) {
			handDir = 3 * sign(handDir) * (sprite_width/64);
			handProgress += handDir
			if(!variable_instance_exists(id, "punchingArm"))
				variable_instance_set(id, "punchingArm", -1);
				
			if(punchingArm == -1)
				punchingArm = choose(0, 1);
			var maxLen = 30 * (sprite_width/64);
			if(abs(handProgress) > maxLen || handProgress <= 0) {
				handDir *= -1;
				if(handProgress <= 0)
					handProgress = 1;
			}
			//use logarithmic graph to have smooth & fast punching movement
			var stretchDist = 30*log10(handProgress);
			var dir = point_direction(x, y, targX, targY);
			if(punchingArm == 0) {
				handB.x = x+lengthdir_x(stretchDist, dir);
				handB.y = y+lengthdir_y(stretchDist, dir);
				var stretchDist2 = abs(sprite_width)*0.2;
				var dir2 = point_direction(x, y, targX, targY);
				handF.x = x+lengthdir_x(stretchDist2, dir2);
				handF.y = y+lengthdir_y(stretchDist2, dir2);
			}
			else if (punchingArm == 1){
				handF.x = x+lengthdir_x(stretchDist, dir);
				handF.y = y+lengthdir_y(stretchDist, dir);
				var stretchDist2 = abs(sprite_width)*0.2;
				var dir2 = point_direction(x, y, targX, targY);
				handB.x = x+lengthdir_x(stretchDist2, dir2);
				handB.y = y+lengthdir_y(stretchDist2, dir2);
			}
		}
		
		function drawFistsUp(armSprBehind, armSprFront, spriteOnHands = spr_boxingGlove) {
			var shouldDrawSprite = is_numeric(spriteOnHands) && spriteOnHands != -1;
			if(handB.x > x) {
				var jointPnt = drawLimbLeftSpr(armSprBehind, armSprBehind, shoulderB.x, shoulderB.y, handB.x, handB.y);
				if(shouldDrawSprite) {
					var dir = point_direction(jointPnt.x, jointPnt.y, handB.x, handB.y);
					draw_sprite_ext(spriteOnHands, 0, handB.x, handB.y, 1, 1, dir, c_white, 1);
				}
				draw_self();
				jointPnt = drawLimbLeftSpr(armSprFront, armSprFront, shoulderF.x, shoulderF.y, handF.x, handF.y);
				if(shouldDrawSprite) {
					var dir = point_direction(jointPnt.x, jointPnt.y, handF.x, handF.y);
					draw_sprite_ext(spriteOnHands, 0, handF.x, handF.y, 1, 1, dir, c_white, 1);
				}
			}
			else {
				var jointPnt = drawLimbRightSpr(armSprBehind, armSprBehind, shoulderB.x, shoulderB.y, handB.x, handB.y);
				if(shouldDrawSprite) {
					var dir = point_direction(jointPnt.x, jointPnt.y, handB.x, handB.y);
					draw_sprite_ext(spriteOnHands, 0, handB.x, handB.y, 1, 1, dir, c_white, 1);
				}
				draw_self();
				jointPnt = drawLimbRightSpr(armSprFront, armSprFront, shoulderF.x, shoulderF.y, handF.x, handF.y);
				if(shouldDrawSprite) {
					var dir = point_direction(jointPnt.x, jointPnt.y, handB.x, handB.y);
					draw_sprite_ext(spriteOnHands, 0, handF.x, handF.y, 1, 1, dir, c_white, 1);
				}
			}
		}
		
		function drawFirearmRifle(gunSpr, armSegmSpr1, armSegmSpr2, xx, yy, targX, targY) {
			var sprW = sprite_get_width(gunSpr);
			var dir = point_direction(xx, yy, targX, targY);
			var arm1Dist = sprW*0.15;
			var arm2Dist = sprW*0.3;
			if(targX > xx)  {
				var tempX = xx+lengthdir_x(arm1Dist, dir-5);
				var tempY = yy+lengthdir_y(arm1Dist, dir-5);
				drawLimbLeftSpr(armSegmSpr1, armSegmSpr2, xx, yy, tempX, tempY);
				draw_self();
				draw_sprite_ext(gunSpr, 0, xx+lengthdir_x(30, dir), yy+lengthdir_y(30, dir), 0.5, 0.5, dir, c_white, 1);
				tempX = xx+lengthdir_x(arm2Dist, dir);
				tempY = yy+lengthdir_y(arm2Dist, dir);			
				drawLimbLeftSpr(armSegmSpr1, armSegmSpr2, xx, yy, tempX, tempY);
			}
			else {
				var tempX = xx+lengthdir_x(arm1Dist, dir+5);
				var tempY = yy+lengthdir_y(arm1Dist, dir+5);
				drawLimbRightSpr(armSegmSpr1, armSegmSpr2, xx, yy, tempX, tempY);
				draw_self();
				draw_sprite_ext(gunSpr, 0, xx+lengthdir_x(30, dir), yy+lengthdir_y(30, dir), 0.5, -0.5, dir, c_white, 1);
				tempX = xx+lengthdir_x(arm2Dist, dir);
				tempY = yy+lengthdir_y(arm2Dist, dir);			
				drawLimbRightSpr(armSegmSpr1, armSegmSpr2, xx, yy, tempX, tempY);
			}
		}
	
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
		//If the slot is holding an item, draw it
		if(item != -1) 
			draw_sprite_ext(item, 0, xx, yy, scl, scl, 0, c_white, 1);
		if(amount > 1) {
			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_text_transformed(xx+78*scl, yy+78*scl, string(amount), 1, 1, 0);
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
		
	function drawInteraction(imageFrame, xx, yy) {
		if(!variable_instance_exists(id, "drawInteractionProgress"))
			variable_instance_set(id, "drawInteractionProgress", 0);
		if(drawInteractionProgress < 1)
			drawInteractionProgress += 1/(room_speed*0.3);
		draw_sprite_part(spr_interactions, imageFrame, 0,0, INTERACTION_W, INTERACTION_H*drawInteractionProgress, xx, yy);
	}
	
	function resetInteractionProgress() {
		if(!variable_instance_exists(id, "drawInteractionProgress"))
			variable_instance_set(id, "drawInteractionProgress", 0);
		drawInteractionProgress = 0;
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