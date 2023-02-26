#region drawing
function drawArms(armBehindSpr, armFrontSpr) {
	var frontArm;
	var behindArm
	if(image_xscale > 0) {
		behindArm = drawLimbLeftSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
		draw_self();
		frontArm = drawLimbLeftSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
	}
	else {
		behindArm = drawLimbRightSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
		draw_self();
		frontArm = drawLimbRightSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
	}
	return {
		front: frontArm,
		behind: behindArm
	}
}
		
function drawLegs(legBehindSpr, legFrontSpr) {
	var behindLeg;
	var frontLeg;
	if(image_xscale > 0) {
		behindLeg = drawLimbRightSpr(legBehindSpr, legBehindSpr, hipB.x, hipB.y, footB.x, footB.y);
		frontLeg = drawLimbRightSpr(legBehindSpr, legBehindSpr, hipF.x, hipF.y, footF.x, footF.y);
		draw_self();
	}
	else {
		behindLeg = drawLimbLeftSpr(legBehindSpr, legBehindSpr, hipB.x, hipB.y, footB.x, footB.y);
		frontLeg = drawLimbLeftSpr(legBehindSpr, legBehindSpr, hipF.x, hipF.y, footF.x, footF.y);
		draw_self();
	}
	return {
		front: frontLeg,
		behind: behindLeg
	}
}
		
function drawLimbRightSpr(segment1Spr, segment2Spr, xx, yy, targX, targY) {
	var segment1Len = sprite_get_width(segment1Spr);
	var dist = point_distance(xx, yy, targX, targY);
	var dir = point_direction(xx, yy, targX, targY);
	var thighDir = darctan(dist/segment1Len);
	thighDir -= dir;
	var jointX = xx+(segment1Len*dsin(thighDir));
	var jointY = yy+(-segment1Len*dcos(thighDir));
	draw_sprite_ext(segment1Spr, 0, xx, yy, 1, 1, point_direction(xx, yy, jointX, jointY), c_white, 1);
		
	var dir = point_direction(jointX, jointY, targX, targY);
	draw_sprite_ext(segment2Spr, 0, jointX, jointY, 1, 1, dir, c_white, 1);
	var footX = jointX+lengthdir_x(sprite_get_width(segment2Spr), dir);
	var footY = jointY+lengthdir_y(sprite_get_width(segment2Spr), dir);
	return {
		joint: new Point(jointX, jointY),
		hand: new Point(footX, footY)
	};
}
	
function drawLimbLeftSpr(segment1Spr, segment2Spr, xx, yy, targX, targY) {
	var segment1Len = sprite_get_width(segment1Spr);
	var dist = point_distance(xx, yy, targX, targY);
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
	var footX = jointX+lengthdir_x(sprite_get_width(segment2Spr), dir);
	var footY = jointY+lengthdir_y(sprite_get_width(segment2Spr), dir);
	return {
		joint: new Point(jointX, jointY),
		hand: new Point(footX, footY)
	};
}
	
function drawHoldingKnife(armBehindSpr, armFrontSpr, knifeSpr, isStabbing, targX, targY) {
	var arms = drawArms(armBehindSpr, armFrontSpr);
	var dir = 0;
	var hand = arms.front.hand;
	
	var tempOffX = sprite_get_xoffset(knifeSpr);
	var tempOffY = sprite_get_xoffset(knifeSpr);
	sprite_set_offset(knifeSpr, ITEM_SIZE/2, ITEM_SIZE/2)
	if(isStabbing) {
		dir = point_direction(x, y, targX, targY);
		if(dir > 90 && dir <= 270)
			dir -= 180
		else if(dir > 270)
			dir -= 270
		draw_sprite_ext(knifeSpr, 0, hand.x, hand.y, 0.2 * image_xscale, 0.2, dir, c_white, 1);
	}
	else
		draw_sprite_ext(knifeSpr, 0, hand.x, hand.y, 0.2 * image_xscale, 0.2, dir, c_white, 1);
	sprite_set_offset(knifeSpr, tempOffX, tempOffY);
}

function drawHoldingSword(armBehindSpr, armFrontSpr, swordSpr, isSwiping, targX, targY, dirFacing = image_xscale) {
	var arms = drawArms(armBehindSpr, armFrontSpr);
	var hand = arms.front.hand;
	var dir = 0;
	var offset = (ITEM_SIZE*0.2)/2;
	var xOffset = (hand.x-offset*dirFacing)+2*dirFacing
	var yOffset = hand.y-offset
	draw_sprite_ext(swordSpr, 0, xOffset, yOffset, 0.2*dirFacing, 0.2, dir, c_white, 1)
}
#endregion drawing

#region movements
function walkMovements(radius, spd, directionFacing = image_xscale) {
	if(abs(x - xprevious) > 0 || abs(y - yprevious) > 0) {
		footProgress += footDir;
		if(footProgress > 360) 
			footProgress = 0;
		footDir = abs(footDir) * sign(directionFacing);
		footDir = spd * sign(footDir) * walkSpd/2;

		//Legs
		{
			footB.x = fBOrigin.x + radius*dcos(footProgress)
			footB.y = fBOrigin.y + radius*dsin(footProgress)
	
			footF.x = fFOrigin.x + radius*dcos(footProgress-180)
			footF.y = fFOrigin.y + radius*dsin(footProgress-180)
		}
	
		//Arms
		{
			handF.x = hFOrigin.x + radius*(walkSpd)*dcos(footProgress-180);
			var yy = radius*(walkSpd)*dsin(footProgress-180);
			if(yy < 0)
				yy *= -1;
			handF.y = hFOrigin.y + yy;
		
			handB.x = hBOrigin.x + radius*(walkSpd)*dcos(footProgress);
			var yy = radius*(walkSpd)*dsin(footProgress);
			if(yy < 0)
				yy *= -1;
			handB.y = hBOrigin.y + yy;
		}
	}
	else {
		//Arms
		{
			var dir = point_direction(handB.x, handB.y, hBOrigin.x, hBOrigin.y);
			var dist = point_distance(handB.x, handB.y, hBOrigin.x, hBOrigin.y)/10;
			handB.x += lengthdir_x(dist, dir);
			handB.y += lengthdir_y(dist, dir);
			
			var dir = point_direction(handF.x, handF.y, hFOrigin.x, hFOrigin.y);
			var dist = point_distance(handF.x, handF.y, hFOrigin.x, hFOrigin.y)/10;
			handF.x += lengthdir_x(dist, dir);
			handF.y += lengthdir_y(dist, dir);
		}
		
		//Legs
		{
			var dir = point_direction(footB.x, footB.y, fBOrigin.x, fBOrigin.y);
			var dist = point_distance(footB.x, footB.y, fBOrigin.x, fBOrigin.y)/10;
			footB.x += lengthdir_x(dist, dir);
			footB.y += lengthdir_y(dist, dir);
			
			var dir = point_direction(footF.x, footF.y, fFOrigin.x, fFOrigin.y);
			var dist = point_distance(footF.x, footF.y, fFOrigin.x, fFOrigin.y)/10;
			footF.x += lengthdir_x(dist, dir);
			footF.y += lengthdir_y(dist, dir);
		}
	}
}

function legWalk(radius, spd, directionFacing = image_xscale) {
	if(abs(x - xprevious) > 0 || abs(y - yprevious) > 0) {
		footProgress += footDir;
		if(footProgress > 360) 
			footProgress = 0;
		footDir = abs(footDir) * sign(directionFacing);
		footDir = spd * sign(footDir) * walkSpd/2;

		//Legs
		{
			footB.x = fBOrigin.x + radius*dcos(footProgress)
			footB.y = fBOrigin.y + radius*dsin(footProgress)
	
			footF.x = fFOrigin.x + radius*dcos(footProgress-180)
			footF.y = fFOrigin.y + radius*dsin(footProgress-180)
		}
	}
	else {
		//Legs
		{
			var dir = point_direction(footB.x, footB.y, fBOrigin.x, fBOrigin.y);
			var dist = point_distance(footB.x, footB.y, fBOrigin.x, fBOrigin.y)/10;
			footB.x += lengthdir_x(dist, dir);
			footB.y += lengthdir_y(dist, dir);
			
			var dir = point_direction(footF.x, footF.y, fFOrigin.x, fFOrigin.y);
			var dist = point_distance(footF.x, footF.y, fFOrigin.x, fFOrigin.y)/10;
			footF.x += lengthdir_x(dist, dir);
			footF.y += lengthdir_y(dist, dir);
		}
	}
}

function armWalk(radius, spd, directionFacing = image_xscale, doProgress = false) {
	if(abs(x - xprevious) > 0 || abs(y - yprevious) > 0) {
		if(doProgress) {
			footProgress += footDir;
			if(footProgress > 360) 
				footProgress = 0;
			footDir = abs(footDir) * sign(directionFacing);
			footDir = spd * sign(footDir) * walkSpd/2;
		}	
		
		//Arms
		{
			handF.x = hFOrigin.x + radius*(walkSpd)*dcos(footProgress-180);
			var yy = radius*(walkSpd)*dsin(footProgress-180);
			if(yy < 0)
				yy *= -1;
			handF.y = hFOrigin.y + yy;
		
			handB.x = hBOrigin.x + radius*(walkSpd)*dcos(footProgress);
			var yy = radius*(walkSpd)*dsin(footProgress);
			if(yy < 0)
				yy *= -1;
			handB.y = hBOrigin.y + yy;
		}
	}
	else {
		//Arms
		{
			var dir = point_direction(handB.x, handB.y, hBOrigin.x, hBOrigin.y);
			var dist = point_distance(handB.x, handB.y, hBOrigin.x, hBOrigin.y)/10;
			handB.x += lengthdir_x(dist, dir);
			handB.y += lengthdir_y(dist, dir);
			
			var dir = point_direction(handF.x, handF.y, hFOrigin.x, hFOrigin.y);
			var dist = point_distance(handF.x, handF.y, hFOrigin.x, hFOrigin.y)/10;
			handF.x += lengthdir_x(dist, dir);
			handF.y += lengthdir_y(dist, dir);
		}
	}
}

function armBehindWalk(radius, spd, directionFacing = image_xscale, doProgress = false) {
	if(abs(x - xprevious) > 0 || abs(y - yprevious) > 0) {
		if(doProgress) {
			footProgress += footDir;
			if(footProgress > 360) 
				footProgress = 0;
			footDir = abs(footDir) * sign(directionFacing);
			footDir = spd * sign(footDir) * walkSpd/2;
		}	
		
		//Arm
		{
			handB.x = hBOrigin.x + radius*walkSpd*dcos(footProgress);
			var yy = radius*(walkSpd)*dsin(footProgress);
			if(yy < 0)
				yy *= -1;
			handB.y = hBOrigin.y + yy;
		}
	}
	else {
		//Arm
		{
			var dir = point_direction(handB.x, handB.y, hBOrigin.x, hBOrigin.y);
			var dist = point_distance(handB.x, handB.y, hBOrigin.x, hBOrigin.y)/10;
			handB.x += lengthdir_x(dist, dir);
			handB.y += lengthdir_y(dist, dir);
		}
	}
}

function knifeStab(distance, targX, targY, duration = 10) {
	
	handProgress += handDir;
	if(handProgress > duration) {
		animType = itemAnimations.NONE;
		handProgress = 1;
	}
		
	var len = distance*log10(handProgress);
	var dir = point_direction(x, y, targX, targY);
	handF.x = x + lengthdir_x(len, dir);
	handF.y = y + lengthdir_y(len, dir);
	
}
	
function swordSwipe(targX, targY, animSpeed, swipeForDegrees = 90, directionFacing = image_xscale) {
	handProgress += handDir*animSpeed*4;
	
	if(abs(handProgress) > swipeForDegrees) {
		animType = itemAnimations.NONE;
		handProgress = 1;
	}
	
	var dir = point_direction(x, y, targX, targY);
	dir = handProgress-(dir*directionFacing)-swipeForDegrees/2;
	dir *= directionFacing;
	
	handF.x = hFOrigin.x + armLen*walkSpd*dcos(dir);
	handF.y = hFOrigin.y + armLen*walkSpd*dsin(dir);
}
#endregion movements