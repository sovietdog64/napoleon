/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

draw_self();
drawLegs(spr_goblinLimbB, spr_goblinLimbF);
drawArms(spr_goblinLimbB, spr_goblinLimbF);
draw_sprite_ext(spr_loincloth, 0, x, y, image_xscale, 1, 0, c_white, 1)