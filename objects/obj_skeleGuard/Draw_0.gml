event_inherited();

draw_self();
drawLegs(spr_skeleLimbB, spr_skeleLimbF);

drawHoldingSword(spr_skeleLimbB, spr_skeleLimbF, spr_ironSword, attackCooldown > 0, obj_player.x, obj_player.y)