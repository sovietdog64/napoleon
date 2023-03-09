event_inherited();

draw_self();
drawLegs(spr_skeleLimbB, spr_skeleLimbF);

drawHoldingKnife(spr_skeleLimbB, spr_skeleLimbF, spr_bow, attackCooldown > 0, obj_player.x, obj_player.y)