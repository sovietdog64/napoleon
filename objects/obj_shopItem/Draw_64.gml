if(!instance_exists(obj_player))
	return;
if(global.gamePaused)
	return;
if(obj_player.state != PlayerStateLocked && distance_to_object(obj_player) <= 150) {
	drawInteraction(0, x-camX(), y-camY()-sprite_width/2);
	if(inspectCooldown > 0)
		inspectCooldown--;
	else if(keyboard_check_pressed(vk_space)) {
		inspectCooldown = 5;
		newTextBox(itemDesc);
		newTextBox(
			"Purchase for " + string(price) + "?",
			["7:Purchase", "0:Exit"]
		)
	}
}
else {
	resetInteractionProgress();
}