/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

draw_self();
drawLegs(spr_goblinLimbB, spr_goblinLimbF);

{//Arms + cloth
	var armBehindSpr = spr_goblinLimbB, armFrontSpr = spr_goblinLimbF;
	if(image_xscale > 0) {
		behindArm = drawLimbLeftSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
		draw_self();
		draw_sprite_ext(spr_goblinRag, 0, x, y, image_xscale, 1, 0, c_white, 1)
		frontArm = drawLimbLeftSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
	}
	else {
		behindArm = drawLimbRightSpr(armBehindSpr, armBehindSpr, shoulderB.x, shoulderB.y, handB.x, handB.y);
		draw_self();
		draw_sprite_ext(spr_goblinRag, 0, x, y, image_xscale, 1, 0, c_white, 1)
		frontArm = drawLimbRightSpr(armFrontSpr, armFrontSpr, shoulderF.x, shoulderF.y, handF.x, handF.y);
	}	
}