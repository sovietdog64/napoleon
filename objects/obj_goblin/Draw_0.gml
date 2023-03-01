/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

draw_self();
drawLegs(spr_goblinLimbB, spr_goblinLimbF);

drawHoldingKnife(spr_goblinLimbB, spr_goblinLimbF, spr_knife, attackCooldown > 0, obj_player.x, obj_player.y)